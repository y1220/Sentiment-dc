class RecommendersController < ApplicationController
  def index
    @users = User.all.order("id")[0..3]
    @tasks = User.first.tasks #NEED FIX: fetch selected user
    @names = User.first(5).map(&:username)
    @analysis = [11, 16, 7, 3, 14] #NEED FIX: analysis need to be implemented based on availability, skill set etc
  end

  def update_clickup
    User.update
    @users = User.all
    @tasks = User.first.tasks
    redirect_to action: "index"
  end
end
