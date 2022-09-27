class AddValueToBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :value, :integer
  end
end
