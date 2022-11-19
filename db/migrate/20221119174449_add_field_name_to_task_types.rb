class AddFieldNameToTaskTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :task_types, :field_name, :string
  end
end
