class CreatePours < ActiveRecord::Migration[4.2]
  def change
    create_table :pours do |t|
      t.integer  :keg_id
      t.integer  :sensor_ticks
      t.decimal  :volume, :precision => 6, :scale => 2
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end

    add_index :pours, :keg_id
  end
end
