class AddSrmToKegs < ActiveRecord::Migration
  def change
    add_column :kegs, :srm, :integer
  end
end
