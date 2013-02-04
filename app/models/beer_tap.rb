class BeerTap < ActiveRecord::Base
  attr_accessible :name, :gpio_pin, :temperature_sensor_id

  belongs_to :temperature_sensor

  has_many :kegs
  has_one :active_keg, class_name: 'Keg', conditions: {active: true}

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end
end
