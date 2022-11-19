class CreateTaskTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :task_types do |t|
      t.string :name
      t.string :cid
      t.string :color

      t.timestamps
    end
    create_join_table :tasks, :task_types do |t|
    end
  end
end
