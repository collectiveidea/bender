class AddHiddenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hidden, :boolean, default: false, null: false
    add_index :users, :hidden
  end
end
