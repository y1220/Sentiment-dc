class AddIndexToDailyReports < ActiveRecord::Migration[5.2]
  def change
    add_index :daily_reports, [:user_id, :register_date, :task_id], unique: true, name: 'task_report_index'
  end
end
