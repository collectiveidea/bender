class AddTempFToTemperatureReadings < ActiveRecord::Migration[4.2]
  def change
    add_column :temperature_readings, :temp_f, :decimal, :precision => 6, :scale => 3
  end
end
