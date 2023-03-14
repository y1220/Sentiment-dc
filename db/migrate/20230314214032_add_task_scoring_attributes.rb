class AddTaskScoringAttributes < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :complexity_score, :float
    add_column :tasks, :priority_score, :float
    add_column :tasks, :duration_score, :float
    add_column :tasks, :frontend_score, :float
    add_column :tasks, :backend_score, :float
    add_column :tasks, :infrastructure_score, :float
    add_column :tasks, :data_manipulation_score, :float
  end
end
