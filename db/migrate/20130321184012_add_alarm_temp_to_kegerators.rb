class AddAlarmTempToKegerators < ActiveRecord::Migration
  def change
    add_column :kegerators, :alarm_temp, :integer
  end
end
