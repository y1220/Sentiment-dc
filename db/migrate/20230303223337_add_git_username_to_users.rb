class AddGitUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :git_username, :string
  end
end
