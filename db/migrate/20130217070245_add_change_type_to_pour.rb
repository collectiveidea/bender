class AddChangeTypeToPour < ActiveRecord::Migration
  def change
  	add_column :pours, :change_type, :string
  end
end
