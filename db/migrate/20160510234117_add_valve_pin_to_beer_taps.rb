class AddValvePinToBeerTaps < ActiveRecord::Migration[4.2]
  def change
    add_column :beer_taps, :valve_pin, :integer
  end
end
