class AddAlarmTempToKegerators < ActiveRecord::Migration[4.2]
  def change
    add_column :kegerators, :alarm_temp, :integer
  end
end
