class AddValvePinToBeerTaps < ActiveRecord::Migration
  def change
    add_column :beer_taps, :valve_pin, :integer
  end
end
