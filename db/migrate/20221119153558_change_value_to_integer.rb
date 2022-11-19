class ChangeValueToInteger < ActiveRecord::Migration[5.2]
  def change
    # change_column(:task_types, :value, :integer)
    remove_column :task_types, :value
  end
end
