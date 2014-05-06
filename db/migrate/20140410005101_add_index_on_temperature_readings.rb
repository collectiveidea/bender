class AddIndexOnTemperatureReadings < ActiveRecord::Migration
  def change
    add_index "temperature_readings", ["temperature_sensor_id", "created_at"], name: 'index_temperature_readings_by_date'
  end
end
