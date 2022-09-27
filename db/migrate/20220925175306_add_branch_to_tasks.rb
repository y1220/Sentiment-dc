class AddBranchToTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :branch, index: true
    add_reference :commits, :branch, index: true
    add_foreign_key :tasks, :branches
    add_foreign_key :commits, :branches
  end
end
