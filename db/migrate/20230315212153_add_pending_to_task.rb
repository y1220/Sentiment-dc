class AddPendingToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :pending, :boolean
  end
end
