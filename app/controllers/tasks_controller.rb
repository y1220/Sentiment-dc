class TasksController < ApplicationController
  @@repo_id = 5

  def index
    @repository = Repository.new
    @tasks = Task.parent_list_of_repo(@@repo_id)
  end

  def show
    @rid = @@repo_id
    @repo_name = Repository.find(@@repo_id).title
    @tasks = Task.parent_list_of_repo(@@repo_id)
    Task.update if @tasks.empty?
  end

  def update_clickup
    Task.update
    @rid = @@repo_id
    @repo_name = Repository.find(@@repo_id).title
    @tasks = Task.parent_list_of_repo(@@repo_id)
    redirect_to action: "show"
  end

  def filter_search
    # params.require(:task).permit(:tag_list)
    @rid = @@repo_id
    @repo_name = Repository.find(@@repo_id).title
    @tasks = Task.parent_list_of_repo(@@repo_id)
    @customizations = Task.tagged_with("customization")
    @externals = Task.tagged_with("external API")
    @internals = Task.tagged_with("internal API")
    @bugs = Task.tagged_with("bug fix")
    @tag_list= [{name: "customization", list: @customizations},
                {name: "external API", list: @externals},
                {name: "internal API", list: @internals},
                {name: "bug fix", list: @bugs}]
    Task.update if @tasks.empty?
  end

  def create
    response = Task.create(params['list_id'], params['title'])
    if !response['id'].nil?
      Task.update
      task = Task.find_by(cid: response['id'])
      issue = GitIssue.find(params['id'])
      issue.task_id = task.id
      if !issue.save
        show_error("Something went wrong..try again!","git_issues/index")
      end
    else
      show_error("Inserted link_id is not acceptable..try again!","git_issues/index")
    end
    redirect_to("/git_issues/index")
  end

  def scoring
    task = Task.find(params['id'])
    if !task
      show_error("Something went wrong..try again!","tasks/index")
    end
    if !task.update(complexity_score: params['complexity_score'], priority_score: params['priority_score'],
      duration_score: params['duration_score'], frontend_score: params['frontend_score'], backend_score: params['backend_score'], infrastructure_score: params['infrastructure_score'], data_manipulation_score: params['data_manipulation_score'])
      show_error("Something went wrong..try again!","tasks/index")
    end
    redirect_to("/tasks/index")
  end

  def update_scoring
  end

end
