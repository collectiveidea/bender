class AddUserIdToPours < ActiveRecord::Migration
  def change
    add_column :pours, :user_id, :integer
  end
end
