class AddSrmToKegs < ActiveRecord::Migration[4.2]
  def change
    add_column :kegs, :srm, :integer
  end
end
