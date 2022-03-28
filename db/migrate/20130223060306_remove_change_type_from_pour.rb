class RemoveChangeTypeFromPour < ActiveRecord::Migration[4.2]
  def change
    remove_column :pours, :change_type
  end
end
