class RecommendersController < ApplicationController
  def index
    @users = User.all
  end
end
