class TasksController < ApplicationController
  def index
  end

  def show
    response = Task.details
    @task_info = response['tasks']
    # byebug
    @task = Task.all
  end
end
