class RenameReadingToTempCOnTemperatureReadings < ActiveRecord::Migration
  def up
    rename_column :temperature_readings, :reading, :temp_c
  end

  def down
    rename_column :temperature_readings, :temp_c, :reading
  end
end
