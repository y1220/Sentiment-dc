class TasksController < ApplicationController
  def index
  end

  def show
    # @task_info = Task.details(params[:id])
    @task = Task.all
  end
end
