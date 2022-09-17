class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :cid
      t.string :name
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
