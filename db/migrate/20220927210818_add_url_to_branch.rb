class AddUrlToBranch < ActiveRecord::Migration[5.2]
  def change
    add_column :branches, :url, :string
  end
end
