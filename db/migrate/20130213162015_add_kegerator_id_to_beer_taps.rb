class AddKegeratorIdToBeerTaps < ActiveRecord::Migration
  def change
    add_column :beer_taps, :kegerator_id, :integer
  end
end
