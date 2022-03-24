class AddCreditsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :credits, :decimal
  end
end
