class CommitsController < ApplicationController

  def index
    @tasks = Task.parent_list
    Task.update if @tasks.empty?
  end

  def update_clickup
    Task.update
    @tasks = Task.parent_list
    redirect_to action: "show"
  end

  def update_link
    @branches = Branch.all
  end
end
