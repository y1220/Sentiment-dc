class GitIssue < ApplicationRecord
  belongs_to :repository
  belongs_to :task

  def self.issues(repo_id)
    hash= ApplicationRecord.authenticate_gitHub
    repo = Repository.find(repo_id)
    username= repo.owner
    repo_name= repo.title
    response = get("/#{username}/#{repo_name}/issues", query: hash[:query], headers: hash[:headers])
    JSON.parse(response.body)
  end

end
