class TasksController < ApplicationController
  @@repo_id = 5

  def index
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

end
