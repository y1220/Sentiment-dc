class TasksController < ApplicationController
  def index
  end

  def show
    @task_info = Task.details(3)
    @task = Task.all
  end
end
