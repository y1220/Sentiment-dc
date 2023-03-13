class AddNumToGitIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :git_issues, :num, :integer
  end
end
