class TapMonitor
  include Celluloid

  def initialize(tap)
    @tap = tap

    @ticks = 0
    @first_tick = Time.now
    @last_tick = Time.now
  end

  def monitor
    pin = Pin.new(:pin => @tap.gpio_pin, :trigger => :rising)
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
      pour.volume       = @ticks * floz_per_tick
      pour.started_at   = @first_tick
      pour.save

      # Waiting for pour to finish
      while @last_tick > (Time.now - Setting.pour_timeout)
        sleep 1
        pour.sensor_ticks = @ticks
        pour.volume       = @ticks * floz_per_tick
        pour.save
      end

      ticks = @ticks
      last_tick = @last_tick
      @ticks = 0

      pour.sensor_ticks = ticks
      pour.volume       = ticks * floz_per_tick
      pour.finished_at  = last_tick
      pour.save
    end
  end
end
