class BeerTap < ActiveRecord::Base
  FLOZ_PER_ML = BigDecimal("0.033814")

  belongs_to :temperature_sensor, optional: true
  belongs_to :kegerator, optional: true

  has_many :kegs, inverse_of: :beer_tap
  has_one :active_keg, lambda { where(active: true) }, class_name: "Keg", inverse_of: :beer_tap

  scope :unused, -> { joins("LEFT JOIN kegs ON kegs.beer_tap_id = beer_taps.id AND kegs.active = true").where(kegs: {id: nil}) }

  def self.for_select
    all.map { |tap| [tap.name, tap.id] }
  end

  def activate
    return true unless valve_pin.present?
    valve_pin_gpio.on
    true
  end

  def deactivate
    return true unless valve_pin.present?
    valve_pin_gpio.off
    true
  end

  def toggle_cleaning
    return true unless valve_pin.present?
    if valve_pin_gpio.off?
      valve_pin_gpio.on
    else
      valve_pin_gpio.off
    end
    true
  end

  def floz_per_tick
    ml_per_tick * FLOZ_PER_ML
  end

  protected

  def valve_pin_gpio
    @_gpio_valve_pin ||= GPIO::Pin.new(pin: valve_pin, direction: :out, invert: Setting.invert_tap_logic)
  end
end
