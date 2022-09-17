class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :cid
      t.string :gid
      t.string :username
      t.integer :role

      t.timestamps
    end
  end
end
