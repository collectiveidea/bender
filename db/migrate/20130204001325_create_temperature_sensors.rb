class CreateTemperatureSensors < ActiveRecord::Migration
  def change
    create_table :temperature_sensors do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
