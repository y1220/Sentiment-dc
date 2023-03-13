class GitIssuesController < ApplicationController
  @@repo_id = 5

  def index
    @rid = @@repo_id
    repo= Repository.find(@@repo_id)
    @repo_name = repo.title
    username= repo.owner
    repo_name= repo.title
    @url = "https://api.github.com/repos/#{username}/#{repo_name}/issues"
    @issues = GitIssue.where(repository_id: @@repo_id)
    GitIssue.update if @issues.empty?
  end

  def update
    repo = Repository.find(@@repo_id)
    if !repo
      show_error("Something went wrong..try again!","admin/user_create")
    end
    response = GitIssue.issues(@@repo_id)
    response.each do |issue|
      title = issue['title']
      number = issue['number']
      git_issue = GitIssue.where(repository_id: @@repo_id, num: number)
      if git_issue.count == 0
        git_issue = GitIssue.new(title: title, repository_id: @@repo_id, num: number)
        if !git_issue.save
          show_error("Something went wrong..try again!","admin/user_create")
        end
      else
        if !git_issue.update(title: title, repository_id: @@repo_id, num: number)
          show_error("Something went wrong..try again!","admin/user_create")
        end
      end
    end
    redirect_to("/git_issues/index")
  end
end
