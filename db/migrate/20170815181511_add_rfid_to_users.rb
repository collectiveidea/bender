class AddRfidToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :rfid, :string
  end
end
