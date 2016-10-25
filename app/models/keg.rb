class Keg < ActiveRecord::Base
  # Capacity is stored in fluid ounces
  KEG_CAPACITIES = [
    ['1/2 Barrel', 1980],
    ['1/4 Barrel', 984],
    ['1/6 Barrel', 636],
    ['Home Brew', 635]
  ]

  belongs_to :beer_tap

  has_many :pours, inverse_of: :keg
  has_one :active_pour, lambda { where(finished_at: nil) }, class_name: 'Pour', inverse_of: :keg

  validates :srm, numericality: {greater_than: 0, less_than: 41, allow_blank: true}

  def display_name
    [name, brewery].reject(&:blank?).join(" by ")
  end

  def completed_pours
    pours.where('finished_at IS NOT NULL')
  end

  def poured
    @poured ||= completed_pours.sum(:volume)
  end

  def poured_percent
    @poured_percent ||= (completed_pours.sum(:volume) / capacity) * 100
  end

  def remaining
    capacity - poured
  end

  def srm_rgb
    I18n.t!("srm.#{srm.to_i}") rescue nil
  end

  def start_pour(user=nil)
    pour = active_pour || pours.new
    pour.user = user if user
    pour.save
    beer_tap.activate
    pour
  end

  def tap_it(tap_id)
    if tap_id.blank?
      errors.add(:beer_tap_id, 'needs to be seleced')
      return
    end

    self.beer_tap_id = tap_id
    self.started_at ||= Time.now
    self.finished_at = nil
    self.active = true
    save
  end

  def untap_it
    self.finished_at = Time.now
    self.active = false
    save
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
      'No projection available'
    else
      Time.now + (Time.now - started_at) / poured * remaining
    end
  end

  def days_on_tap
    return 0 unless started_at
    (((finished_at || Time.now) - started_at) / 1.day).round
  end
end
