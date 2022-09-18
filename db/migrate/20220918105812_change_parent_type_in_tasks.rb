class ChangeParentTypeInTasks < ActiveRecord::Migration[5.2]
  def change
    change_column(:tasks, :parent, :string)
  end
end
