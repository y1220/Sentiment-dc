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

end
