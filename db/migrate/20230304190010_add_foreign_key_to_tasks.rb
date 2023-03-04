class AddForeignKeyToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :repository, index: true
  end
end
