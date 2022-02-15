class UpPrecisionOfReadingOnTemperatureReadings < ActiveRecord::Migration[4.2]
  def up
    change_column :temperature_readings, :reading, :decimal, :precision => 6, :scale => 3
  end

  def down
    change_column :temperature_readings, :reading, :decimal, :precision => 5, :scale => 2
  end
end
