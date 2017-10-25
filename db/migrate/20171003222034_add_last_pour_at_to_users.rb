class AddLastPourAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_pour_at, :datetime
  end
end
