class AddRegisteredToDailyReports < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_reports, :registered, :boolean
  end
end
