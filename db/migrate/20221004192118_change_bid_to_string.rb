class ChangeBidToString < ActiveRecord::Migration[5.2]
  def change
    change_column(:branches, :bid, :string)
  end
end
