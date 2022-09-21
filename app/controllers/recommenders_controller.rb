class RecommendersController < ApplicationController
  def index
    @users = User.all
    @tasks = User.first.tasks # need fix :fetch selected user
  end
end
