# Sensor ticks is stored for calibration purposes only

# Volume is stored in fluid ounces
# however most sensors report as pulses per L
# Swissflow: between 5400 to 6100 pulses/L
# ml * 0.033814 = fl oz

class Pour < ActiveRecord::Base
	attr_accessible :user_id, :change_type, :sensor_ticks, :volume, :started_at, :finished_at

  belongs_to :keg
  belongs_to :user
end
