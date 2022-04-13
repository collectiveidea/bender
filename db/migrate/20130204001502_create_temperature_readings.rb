class CreateTemperatureReadings < ActiveRecord::Migration[4.2]
  def change
    create_table :temperature_readings do |t|
      t.integer :temperature_sensor_id
      t.decimal :reading, precision: 5, scale: 2
      t.datetime :created_at
    end

    add_index :temperature_readings, :temperature_sensor_id
  end
end
