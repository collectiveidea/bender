class AddDurationToPour < ActiveRecord::Migration
  def change
    add_column :pours, :duration, :float
  end
end
