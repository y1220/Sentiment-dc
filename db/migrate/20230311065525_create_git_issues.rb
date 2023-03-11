class CreateGitIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :git_issues do |t|
      t.string :title
      t.references :repository, foreign_key: true
      t.references :task, foreign_key: true

      t.timestamps
    end

  end
end
