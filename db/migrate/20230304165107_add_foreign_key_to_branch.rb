class AddForeignKeyToBranch < ActiveRecord::Migration[5.2]
  def change
    add_reference :branches, :repository, index: true
  end
end
