class GitIssue < ApplicationRecord
  belongs_to :repository
  belongs_to :task

  include HTTParty
  base_uri "https://api.github.com/repos"

  def self.issues(repo_id)
    hash= ApplicationRecord.authenticate_gitHub
    repo = Repository.find(repo_id)
    username= repo.owner
    repo_name= repo.title
    response = get("/#{username}/#{repo_name}/issues", query: hash[:query], headers: hash[:headers])
    JSON.parse(response.body)
  end

  def format_date_created
    self.created_at.present? ? self.created_at.strftime('%m-%d-%Y %l:%M %p') : nil
  end

  def format_date_updated
    self.updated_at.present? ? self.updated_at.strftime('%m-%d-%Y %l:%M %p') : nil
  end

end
