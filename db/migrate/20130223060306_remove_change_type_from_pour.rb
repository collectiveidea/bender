class RemoveChangeTypeFromPour < ActiveRecord::Migration
  def change
  	remove_column :pours, :change_type
  end
end