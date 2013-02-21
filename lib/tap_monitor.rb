class TapMonitor
  TICKS      = 0
  FIRST_TICK = 1
  LAST_TICK  = 2

  def self.monitor_taps
    require 'raindrops'

    tap_monitors = {}
    loop do
      begin
        cpid, status = Process.waitpid2(-1, Process::WNOHANG)
        break if cpid.nil?
        tap_monitors.delete_if {|_,pid| pid == cpid}
      rescue Errno::ECHILD
        break
      end while true


      BeerTap.all.each do |tap|
        tap_monitors[tap.id] ||= start(tap)
      end

      sleep 60
    end
  end

  def self.start(tap)
    ActiveRecord::Base.connection_pool.disconnect!
    fork { new(tap).monitor }
  end

  def initialize(tap)
    @tap = tap

    @drop = Raindrops.new(3)

    @drop[TICKS] = 0
  end

  def monitor
    start_pour_monitor

    pin = GPIO::Pin.new(:pin => @tap.gpio_pin, :trigger => :rising)
    loop do
      pin.wait_for_change

      @drop[FIRST_TICK] = Time.now.to_i if @drop[TICKS] == 0
      @drop[LAST_TICK]  = Time.now.to_i
      @drop.incr(TICKS)
    end
  end

  def start_pour_monitor
    Thread.new do
      loop do
        begin
          cpid, status = Process.waitpid2(-1, Process::WNOHANG)
          start_sub_process if cpid
        rescue Errno::ECHILD
          start_sub_process
        end
        sleep(10)
      end
    end
  end

  def start_sub_process
    ActiveRecord::Base.connection_pool.disconnect!
    fork { monitor_pour }
  end

  def monitor_pour
    loop do
      sleep(1) while @drop[TICKS] == 0

      pour = @tap.active_keg(true).active_pour(true) || @tap.active_keg.pours.new
      pour.sensor_ticks = @drop[TICKS]
      pour.volume       = pour.sensor_ticks * @tap.floz_per_tick
      pour.started_at   = Time.at(@drop[FIRST_TICK])
      pour.save

      # Waiting for pour to finish
      while @drop[LAST_TICK] > (Time.now.to_i - Setting.pour_timeout)
        sleep 1
        pour.sensor_ticks = @drop[TICKS]
        pour.volume       = pour.sensor_ticks * @tap.floz_per_tick
        pour.save
      end

      ticks = @drop[TICKS]
      last_tick = Time.at(@drop[LAST_TICK])
      @drop[TICKS] = 0

      pour.sensor_ticks = ticks
      pour.volume       = ticks * @tap.floz_per_tick
      pour.finished_at  = last_tick
      pour.save
    end
  end
end
