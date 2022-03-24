class AddDurationToPour < ActiveRecord::Migration[4.2]
  def change
    add_column :pours, :duration, :float
  end
end
