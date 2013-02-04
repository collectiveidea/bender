class Keg < ActiveRecord::Base
  attr_accessible :name, :description, :capacity

  # Capacity is stored in fluid ounces
  KEG_CAPACITIES = [
    ['1/2 Barrel', 1980],
    ['1/4 Barrel', 984],
    ['1/6 Barrel', 636],
    ['Home Brew', 636]
  ]

  belongs_to :beer_tap

  has_many :pours
  has_one :active_pour, class_name: 'Pour', conditions: {finished_at: nil}

  def poured
    @poured ||= pours.sum(:volume)
  end

  def remaining
    self.capacity - poured
  end

  def tap_it(tap_id)
    if tap_id.blank?
      self.errors.add(:beer_tap_id, 'needs to be seleced')
      return
    end

    self.beer_tap_id = tap_id
    self.started_at ||= Time.now
    self.finished_at = nil
    self.active = true
    self.save
  end

  def untap_it
    self.finished_at = Time.now
    self.active = false
    self.save
  end
end
