class AddValueToTaskTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :task_types, :value, :string
  end
end
