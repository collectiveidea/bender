class CreateKegs < ActiveRecord::Migration
  def change
    create_table :kegs do |t|
      t.integer :beer_tap_id
      t.string  :name
      t.text    :description
      t.boolean :active
      t.integer :capacity
      t.timestamps
    end

    add_index :kegs, :beer_tap_id
  end
end
