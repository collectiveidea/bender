class AddStartedAtAndFinishedAtToKegs < ActiveRecord::Migration[4.2]
  def change
    change_table :kegs, bulk: true do |t|
      t.datetime :started_at
      t.datetime :finished_at
    end
  end
end
