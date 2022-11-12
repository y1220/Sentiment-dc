class AddCtidCuidToDailyReports < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_reports, :cuid, :string
  end
end
