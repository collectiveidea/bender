require "gpio"

class TapMonitor
  attr_reader :io

  class << self
    attr_accessor :tap_monitors
    attr_accessor :running

    def monitor_taps
      self.tap_monitors = {}
      @running = true

      trap(:INT) { TapMonitor.running = false }
      trap(:TERM) { TapMonitor.running = false }
      trap(:QUIT) { TapMonitor.running = false }
      trap(:CLD) {
        TapMonitor.check_dead
        TapMonitor.start_missing
      }

      monitor_loop

      # We are done here. Tell all subprocess to quit
      tap_monitors.each_value { |monitor| Process.kill("TERM", monitor.pid) }

      # Wait for the subprocesses to finish
      tap_monitors.each_value { |monitor| Process.wait(monitor.pid) }
    end

    def check_dead
      cpid, _ = Process.waitpid2(-1, Process::WNOHANG)
      return if cpid.nil?
      tap_monitors.delete_if do |_, monitor|
        if monitor.pid == cpid
          monitor.close
          true
        else
          false
        end
      end
    rescue Errno::ECHILD
    end

    def start_missing
      return unless @running

      BeerTap.all.each do |tap|
        tap_monitors[tap.id] ||= start(tap)
      end
    end

    def monitor_loop
      while @running
        check_dead
        start_missing

        monitors = tap_monitors.values
        ios = IO.select(monitors.map { |mon| mon.io }, [], [], 1)
        if ios
          ios[0].each do |io|
            monitor = monitors.detect { |mon| mon.io == io }
            monitor.update
          end
        end

        tap_monitors.each_value(&:finish_if_needed)
      end
    end

    def start(tap)
      new(tap)
    end
  end

  def initialize(tap)
    @tap = tap
    @running = true
    @finished = true
    @last_started_at = Time.now.to_f.to_s

    @io = IO.popen("#{ruby_version} #{Rails.root.join("lib", "pour_reader.rb").to_s.inspect} #{@tap.gpio_pin} #{Setting.pour_timeout}", "r+")
    @io.sync = true
  end

  def ruby_version
    ENV.fetch("MRUBY_BIN", "ruby")
  end

  def close
    finish_if_needed
    @io.close
  end

  def pid
    @io.pid
  end

  def finish_if_needed
    return if @finished

    if @active_pour.finished_at.nil?
      @active_pour.reload
      @timeout = 2 if @active_pour.finished_at.present?
    end

    if (@last_tick + @timeout) < Time.now
      finish
    end
  end

  def update
    # Read update
    _, @first_tick, @last_tick, @ticks = @io.readline.strip.split(",")
    @last_tick = Time.at(@last_tick.to_f)

    # Is this a new pour
    if @last_started_at != @first_tick
      @active_pour = nil
      @last_started_at = @first_tick
      @timeout = Setting.pour_timeout
      @finished = false
    end

    # is there an active pour or keg
    keg = @tap.active_keg(true) if @active_pour.nil?
    return if @active_pour.nil? && keg.nil?

    # reload, find, or create the active pour
    @active_pour&.reload
    @active_pour ||= keg.active_pour(true) || keg.pours.new
    @active_pour.started_at ||= Time.at(@first_tick.to_f)

    # fast timeout as the user has said they are done
    @timeout = 2 if @active_pour.finished_at.present?

    # update the volume
    @active_pour.sensor_ticks = @ticks
    @active_pour.volume = @active_pour.sensor_ticks * @tap.floz_per_tick

    # is the pour done
    if (@last_tick + @timeout) < Time.now
      finish
      @io.puts "reset"
      @io.flush
    else
      @active_pour.save
    end
  rescue EOFError
    finish_if_needed
  end

  def finish
    @finished = true
    if @active_pour.volume < 0.5
      @active_pour.destroy
    else
      @active_pour.finished_at = @last_tick
      @active_pour.save
    end
    @active_pour.keg.beer_tap.deactivate
  end
end
