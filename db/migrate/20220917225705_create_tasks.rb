class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :cid
      t.string :name
      t.text :description
      t.boolean :parent
      t.string :url
      t.integer :status
      t.boolean :archived
      t.datetime :due_date
      t.datetime :data_created
      t.datetime :data_closed
      t.references :list, foreign_key: true

      t.timestamps
    end
  end
end
