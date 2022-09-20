class AddLastStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_status, :integer
  end
end
