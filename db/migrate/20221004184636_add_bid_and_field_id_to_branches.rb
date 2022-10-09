class AddBidAndFieldIdToBranches < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :bid, :integer
    add_column :branches, :field_id, :string
  end
end
