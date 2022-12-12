class TasksController < ApplicationController
  def index
  end

  def show
    @tasks = Task.parent_list
    Task.update if @tasks.empty?
  end

  def update_clickup
    Task.update
    @tasks = Task.parent_list
    redirect_to action: "show"
  end

  def filter_search
    # params.require(:task).permit(:tag_list)
    @tasks = Task.parent_list
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
