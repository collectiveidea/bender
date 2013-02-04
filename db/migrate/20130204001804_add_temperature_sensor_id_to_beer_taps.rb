class AddTemperatureSensorIdToBeerTaps < ActiveRecord::Migration
  def change
    add_column :beer_taps, :temperature_sensor_id, :integer
  end
end
