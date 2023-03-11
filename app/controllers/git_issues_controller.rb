class GitIssuesController < ApplicationController
  @@repo_id = 5

  def index
    @rid = @@repo_id
    @repo_name = Repository.find(@@repo_id).title
    @tasks = Task.parent_list_of_repo(@@repo_id)
    Task.update if @tasks.empty?
  end
end
