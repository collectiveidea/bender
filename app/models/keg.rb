class Keg < ActiveRecord::Base
  attr_accessible :name, :description

  belongs_to :beer_tap

  has_many :pours
  has_one :active_pour, class_name: 'Pour', conditions: {finished_at: nil}
end
