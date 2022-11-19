class RemoveValueFromTaskTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :task_types, :value
  end
end
