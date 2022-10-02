class AddCidToCommits < ActiveRecord::Migration[5.2]
  def change
    add_column :commits, :cid, :string
  end
end
