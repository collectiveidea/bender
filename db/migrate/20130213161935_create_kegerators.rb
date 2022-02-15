class CreateKegerators < ActiveRecord::Migration[4.2]
  def change
    create_table :kegerators do |t|
      t.string   :name
      t.integer  :temperature_sensor_id
      t.integer  :min_temp
      t.integer  :max_temp
      t.integer  :control_pin
      t.datetime :last_shutdown

      t.timestamps
    end
  end
end
