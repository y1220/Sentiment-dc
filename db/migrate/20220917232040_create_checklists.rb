class CreateChecklists < ActiveRecord::Migration[5.2]
  def change
    create_table :checklists do |t|
      t.string :cid
      t.string :name
      t.integer :resolved
      t.integer :unresolved
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
