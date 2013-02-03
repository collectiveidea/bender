class BeerTap < ActiveRecord::Base
  attr_accessible :name, :gpio_pin

  has_many :kegs
  has_one :active_keg, class_name: 'Keg', conditions: {active: true}

  def self.for_select
    all.map {|tap| [tap.name, tap.id] }
  end
end
