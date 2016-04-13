class BeerTap < ActiveRecord::Base
  FLOZ_PER_ML = BigDecimal.new('0.033814')

  belongs_to :temperature_sensor
  belongs_to :kegerator

  has_many :kegs, inverse_of: :beer_tap
  has_one :active_keg, lambda { where(active: true) }, class_name: 'Keg', inverse_of: :beer_tap

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end

  def floz_per_tick
    ml_per_tick * FLOZ_PER_ML
  end
end
