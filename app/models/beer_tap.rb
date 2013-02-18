class BeerTap < ActiveRecord::Base
  FLOZ_PER_ML = BigDecimal.new('0.033814')

  attr_accessible :name, :gpio_pin, :temperature_sensor_id, :ml_per_tick

  belongs_to :temperature_sensor
  belongs_to :kegerator

  has_many :kegs
  has_one :active_keg, class_name: 'Keg', conditions: {active: true}

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end

  def self.monitor
    all.each do |tap|
      TapMonitor.new(tap).async.monitor
    end
    while true; sleep 60; end
  end

  def floz_per_tick
    ml_per_tick * FLOZ_PER_ML
  end
end
