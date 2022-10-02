class AddCommitDateToCommits < ActiveRecord::Migration[5.2]
  def change
    add_column :commits, :commit_date, :datetime
  end
end
