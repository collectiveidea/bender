class CreateBeerTaps < ActiveRecord::Migration[4.2]
  def change
    create_table :beer_taps do |t|
      t.string  :name
      t.integer :gpio_pin
      t.timestamps
    end
  end
end
