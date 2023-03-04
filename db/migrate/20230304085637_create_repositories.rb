class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :title
      t.text :description
      t.string :owner

      t.timestamps
    end
  end
end
