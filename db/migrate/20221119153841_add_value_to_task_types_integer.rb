class AddValueToTaskTypesInteger < ActiveRecord::Migration[5.2]
  def change
    add_column :task_types, :value, :integer
  end
end
