class Keg < ActiveRecord::Base
  attr_accessible :name, :brewery, :style, :abv, :description, :capacity

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

  def completed_pours
    pours.where('finished_at IS NOT NULL')
  end

  def poured
    @poured ||= completed_pours.sum(:volume)
  end

  def remaining
    self.capacity - poured
  end

  def start_pour(user = nil)
    pour = active_pour || pours.new
    pour.user = user if user
    pour.save
    pour
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

  def temp_data
    if sensor = beer_tap.temperature_sensor
      sensor.temp_data
    else
      []
    end
  end

  def top_consumers
    pours.select('name, sum(volume) as total, count(pours.id) as count, avg(volume) as average, max(volume) as max').group('users.name').order('total desc').joins(:user)
  end

  def projected_empty
    if poured == 0 || remaining == 0
      "No projection available"
    else
      Time.now + (Time.now - started_at) / poured * remaining
    end
  end
end
