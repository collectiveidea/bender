class BeerTap < ActiveRecord::Base
  FLOZ_PER_ML = BigDecimal.new('0.033814')

  belongs_to :temperature_sensor
  belongs_to :kegerator

  has_many :kegs, inverse_of: :beer_tap
  has_one :active_keg, lambda { where(active: true) }, class_name: 'Keg', inverse_of: :beer_tap

  scope :unused, -> { joins("LEFT JOIN kegs ON kegs.beer_tap_id = beer_taps.id AND kegs.active = true").where(kegs: {id: nil}) }

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end

  def activate
    return true unless valve_pin.present?
    GPIO::Pin.new(pin: valve_pin, direction: :out).on
    true
  end

  def deactivate
    return true unless valve_pin.present?
    GPIO::Pin.new(pin: valve_pin, direction: :out).off
    true
  end

  def floz_per_tick
    ml_per_tick * FLOZ_PER_ML
  end
end
