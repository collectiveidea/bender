class BeerTap < ActiveRecord::Base
  FLOZ_PER_ML = BigDecimal.new('0.033814')

  attr_accessible :name, :gpio_pin, :temperature_sensor_id, :ml_per_tick

  belongs_to :temperature_sensor

  has_many :kegs
  has_one :active_keg, class_name: 'Keg', conditions: {active: true}

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end

  def self.monitor
    all.each do |tap|
      tap.monitor
    end
    while true; sleep 60; end
  end

  def floz_per_tick
    ml_per_tick * FLOZ_PER_ML
  end

  def monitor
    return unless active_keg

    Thread.new do
      @ticks = 0
      @first_tick = Time.now
      @last_tick = Time.now

      GPIO.watch(:pin => gpio_pin) do |pin|
        if pin.value == 1
          @ticks += 1
          @last_tick = Time.now
          @first_tick = Time.now if @ticks == 1
        end
      end

      loop do
        # Waiting for a pour to begin
        while @ticks == 0
          sleep 1
        end

        pour = active_keg.active_pour || active_keg.pours.new
        pour.attributes = {sensor_ticks: @ticks, volume: @ticks * floz_per_tick, started_at: @first_tick}
        pour.save

        # Waiting for pour to finish
        while @last_tick > (Time.now - 10)
          sleep 1
          pour.update_attributes(sensor_ticks: @ticks, volume: @ticks * floz_per_tick)
        end

        ticks = @ticks
        last_tick = @last_tick
        @ticks = 0

        pour.update_attributes(sensor_ticks: ticks, volume: ticks * floz_per_tick, finished_at: last_tick)
      end
    end
  end
end
