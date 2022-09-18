class RenameDateCreatedClosed2 < ActiveRecord::Migration[5.2]
  def change
    rename_column :tasks, :data_created, :date_created
    rename_column :tasks, :data_closed, :date_closed
  end
end
