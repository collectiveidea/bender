class AddBeerAttributesToKeg < ActiveRecord::Migration
  def change
    add_column :kegs, :brewery, :string
    add_column :kegs, :style, :string
    add_column :kegs, :abv, :decimal
  end
end
