class PourMonitor
  TICKS      = TapMonitor::TICKS
  FIRST_TICK = TapMonitor::FIRST_TICK
  LAST_TICK  = TapMonitor::LAST_TICK

  def self.start(tap, drop)
    ActiveRecord::Base.connection_pool.disconnect!
    fork { new(tap, drop).monitor }
  end

  def initialize(tap, drop)
    @tap     = tap
    @drop    = drop
    @running = true
  end

  def monitor
    trap(:INT)  { @running = false }
    trap(:TERM) { @running = false }
    trap(:QUIT) { @running = false }

    while @running
      sleep(1) while @running && @drop[TICKS] == 0

      # Stop if we have been told to. Unless a pour
      # has begun, then finish the pour first
      break if !@running && @drop[TICKS] == 0

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

      ticks     = @drop[TICKS]
      last_tick = Time.at(@drop[LAST_TICK])
      @drop[TICKS] = 0

      pour.sensor_ticks = ticks
      pour.volume       = ticks * @tap.floz_per_tick
      pour.finished_at  = last_tick
      pour.save
    end
  end
end
