class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces do |t|
      t.string :cid
      t.string :name

      t.timestamps
    end
  end
end
