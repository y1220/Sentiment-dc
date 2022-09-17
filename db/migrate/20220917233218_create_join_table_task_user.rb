class CreateJoinTableTaskUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :tasks, :users do |t|
      t.index [:task_id, :user_id]
      t.index [:user_id, :task_id]
    end
  end
end
