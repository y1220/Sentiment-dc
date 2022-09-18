class CreatePropertySettings < ActiveRecord::Migration[5.2]
  def change
    create_table :property_settings do |t|
      t.string :company
      t.string :key_name
      t.string :value_text
      t.boolean :enabled

      t.timestamps
    end
  end
end
