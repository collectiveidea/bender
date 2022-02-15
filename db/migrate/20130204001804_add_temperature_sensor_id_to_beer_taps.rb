class AddTemperatureSensorIdToBeerTaps < ActiveRecord::Migration[4.2]
  def change
    add_column :beer_taps, :temperature_sensor_id, :integer
  end
end
