class AddDisplayOrderToBeerTaps < ActiveRecord::Migration[4.2]
  def change
    add_column :beer_taps, :display_order, :integer
  end
end
