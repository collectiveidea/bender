class AddBeerAttributesToKeg < ActiveRecord::Migration[4.2]
  def change
    change_table :kegs, bulk: true do |t|
      t.string :brewery
      t.string :style
      t.decimal :abv
    end
  end
end
