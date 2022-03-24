class AddChangeTypeToPour < ActiveRecord::Migration[4.2]
  def change
  	add_column :pours, :change_type, :string
  end
end
