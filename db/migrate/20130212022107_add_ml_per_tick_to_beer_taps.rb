class AddMlPerTickToBeerTaps < ActiveRecord::Migration[4.2]
  def change
    add_column :beer_taps, :ml_per_tick, :decimal, :precision => 6, :scale => 5
  end
end
