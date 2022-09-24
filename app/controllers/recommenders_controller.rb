class RecommendersController < ApplicationController
  def index
    @users = User.all.order("id")[0..3]
    @tasks = User.first.tasks # need fix :fetch selected user
  end

  def update_clickup
    User.update
    @users = User.all
    @tasks = User.first.tasks
    redirect_to action: "index"
  end
end
