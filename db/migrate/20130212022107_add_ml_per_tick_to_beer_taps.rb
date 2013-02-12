class AddMlPerTickToBeerTaps < ActiveRecord::Migration
  def change
    add_column :beer_taps, :ml_per_tick, :decimal, :precision => 6, :scale => 5
  end
end
