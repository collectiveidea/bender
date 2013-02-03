class BeerTap < ActiveRecord::Base
  attr_accessible :name, :gpio_pin

  has_many :kegs
  has_one :active_keg, class_name: 'Keg', conditions: {active: true}
end
