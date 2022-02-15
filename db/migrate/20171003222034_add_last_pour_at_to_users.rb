class AddLastPourAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_pour_at, :datetime
  end
end
