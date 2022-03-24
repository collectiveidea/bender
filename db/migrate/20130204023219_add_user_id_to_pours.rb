class AddUserIdToPours < ActiveRecord::Migration[4.2]
  def change
    add_column :pours, :user_id, :integer
  end
end
