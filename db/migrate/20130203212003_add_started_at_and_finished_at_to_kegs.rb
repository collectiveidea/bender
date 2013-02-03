class AddStartedAtAndFinishedAtToKegs < ActiveRecord::Migration
  def change
    add_column :kegs, :started_at, :datetime
    add_column :kegs, :finished_at, :datetime
  end
end
