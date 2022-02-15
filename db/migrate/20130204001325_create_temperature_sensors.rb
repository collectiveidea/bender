class CreateTemperatureSensors < ActiveRecord::Migration[4.2]
  def change
    create_table :temperature_sensors do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
