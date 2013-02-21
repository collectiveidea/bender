class TapMonitor
  TICKS      = 0
  FIRST_TICK = 1
  LAST_TICK  = 2

  def self.monitor_taps
    require 'raindrops'

    tap_monitors = {}
    @running = true

    trap(:INT)  { @running = false }
    trap(:TERM) { @running = false }
    trap(:QUIT) { @running = false }

    while @running
      # Check for processes which have exitted
      begin
        cpid, status = Process.waitpid2(-1, Process::WNOHANG)
        break if cpid.nil?
        tap_monitors.delete_if {|_,pid| pid == cpid }
      rescue Errno::ECHILD
        break
      end while true

      # Start new monitors
      if @running
        BeerTap.all.each do |tap|
          tap_monitors[tap.id] ||= start(tap)
        end
      end

      # We want to exit fast but only hit the database once per minute
      60.times do
        sleep 1 if @running
      end
    end

    # We are done here. Tell all subprocess to quit
    tap_monitors.each_value {|pid| Process.kill('TERM', pid) }

    # Wait for the subprocesses to finish
    begin
      Process.waitpid2(-1)
    rescue Errno::ECHILD
      break
    end while true
  end

  def self.start(tap)
    # We don't want to share connections between processes
    ActiveRecord::Base.connection_pool.disconnect!
    fork { new(tap).monitor }
  end

  def initialize(tap)
    @tap     = tap
    @running = true
    @drop    = Raindrops.new(3)

    @drop[TICKS] = 0
  end

  def monitor
    trap(:INT)  { @running = false }
    trap(:TERM) { @running = false }
    trap(:QUIT) { @running = false }

    pour_monitor = start_pour_monitor

    @pin = GPIO::Pin.new(:pin => @tap.gpio_pin, :trigger => :rising)
    # Loop while we are running or a pour is in progress
    while @running || @drop[TICKS] > 0
      @pin.wait_for_change
      break if !@running && @drop[TICKS] == 0

      @drop[FIRST_TICK] = Time.now.to_i if @drop[TICKS] == 0
      @drop[LAST_TICK]  = Time.now.to_i
      @drop.incr(TICKS)
    end

    pour_monitor.join
  end

  def start_pour_monitor
    Thread.new do
      while @running || @drop[TICKS] > 0
        begin
          cpid, status = Process.waitpid2(-1, Process::WNOHANG)
          @sub_process_pid = PourMonitor.start(@tap, @drop) if cpid
        rescue Errno::ECHILD
          @sub_process_pid = PourMonitor.start(@tap, @drop)
        end

        # Wait at least 1 second.
        sleep 1

        # I want to exit fast but only check for a
        # dead subprocess every 10 seconds
        9.times do
          sleep 1 if @running
        end
      end

      @pin.break_wait_for_change

      Process.kill('TERM', @sub_process_pid)

      begin
        Process.waitpid2(-1)
      rescue Errno::ECHILD
      end
    end
  end

end
