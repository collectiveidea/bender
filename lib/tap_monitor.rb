class TapMonitor
  def self.monitor_taps
    tap_monitors = {}
    loop do
      tap_monitors.each do |tap_id, thread|
        case thread.status
        when nil # Thread died with an error
          if tap = BeerTap.find_by_id(tap_id)
            # Restart the monitor
            tap_monitors[tap.id] = start(tap)
          else
            # Tap has been removed
            tap_monitors.delete(tap_id)
          end
        when false # Thread exitted cleanly
          tap_monitors.delete(tap_id)
        end
      end

      BeerTap.all.each do |tap|
        tap_monitors[tap.id] ||= start(tap)
      end

      sleep 60
    end
  end

  def self.start(tap)
    Thread.new { new(tap).monitor }
  end

  def initialize(tap)
    @tap = tap

    @ticks = 0
    @first_tick = Time.now
    @last_tick = Time.now
  end

  def monitor
    pin = GPIO::Pin.new(:pin => @tap.gpio_pin, :trigger => :rising)
    loop do
      pin.wait_for_change

      @ticks += 1
      @last_tick = Time.now
      if @ticks == 1
        @first_tick = @last_tick
        start_pour
      end
    end
  end

  def start_pour
    Thread.new do
      pour = @tap.active_keg(true).active_pour(true) || @tap.active_keg.pours.new
      pour.sensor_ticks = @ticks
      pour.volume       = @ticks * @tap.floz_per_tick
      pour.started_at   = @first_tick
      pour.save

      # Waiting for pour to finish
      while @last_tick > (Time.now - Setting.pour_timeout)
        sleep 1
        pour.sensor_ticks = @ticks
        pour.volume       = @ticks * @tap.floz_per_tick
        pour.save
      end

      ticks = @ticks
      last_tick = @last_tick
      @ticks = 0

      pour.sensor_ticks = ticks
      pour.volume       = ticks * @tap.floz_per_tick
      pour.finished_at  = last_tick
      pour.save
    end
  end
end
