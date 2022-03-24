class AddKegeratorIdToBeerTaps < ActiveRecord::Migration[4.2]
  def change
    add_column :beer_taps, :kegerator_id, :integer
  end
end
