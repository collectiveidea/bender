# Sensor ticks is stored for calibration purposes only

# Volume is stored in fluid ounces
# however most sensors report as pulses per L
# Swissflow: between 5400 to 6100 pulses/L
# ml * 0.033814 = fl oz

class Pour < ActiveRecord::Base
  belongs_to :keg
  belongs_to :user

  before_save :calculate_duration

  scope :finished, lambda { where('finished_at IS NOT NULL') }
  scope :non_guest, lambda { where('user_id > 0') }
  scope :for_listing, lambda { where('volume IS NOT NULL').includes(:keg, :user).order('created_at desc') }

  def self.between_dates(start_time:, end_time:)
    start_time ||= 10.years.ago
    end_time ||= 10.years.from_now

    where(created_at: start_time..end_time)
  end

  def finish_pour(time)
    self.finished_at = time
    if sensor_ticks.to_i == 0
      keg.beer_tap.deactivate
      destroy
    else
      save
    end
  end

  def complete?
    finished_at.nil? ? false : (Time.now - finished_at) > Setting.pour_timeout
  end

  private

  def calculate_duration
    self.duration = finished_at - started_at if finished_at && started_at
  end
end
