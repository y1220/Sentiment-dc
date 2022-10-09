class AddTaskIdToDailyReport < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_reports, :task_id, :integer
    add_column :daily_availabilities, :task_id, :integer
  end
end
