class AddCreditsToUser < ActiveRecord::Migration
  def change
    add_column :users, :credits, :decimal
  end
end
