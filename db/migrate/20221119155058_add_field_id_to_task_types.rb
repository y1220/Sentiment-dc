class AddFieldIdToTaskTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :task_types, :field_id, :string
  end
end
