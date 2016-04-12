class AddDisplayOrderToBeerTaps < ActiveRecord::Migration
  def change
    add_column :beer_taps, :display_order, :integer
  end
end
