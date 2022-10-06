class RemoveTaskIdFromDailyAvailabilities < ActiveRecord::Migration[5.2]
  def change
    remove_column :daily_availabilities, :task_id
  end
end
