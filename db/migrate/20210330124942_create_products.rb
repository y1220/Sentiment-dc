class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :vendor

      t.timestamps null: false
    end
  end
end
