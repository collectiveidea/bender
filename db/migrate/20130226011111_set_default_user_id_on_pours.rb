class SetDefaultUserIdOnPours < ActiveRecord::Migration
  def up
    change_column :pours, :user_id, :integer, :null => false, :default => 0
  end

  def down
    change_column :pours, :user_id, :integer
  end
end
