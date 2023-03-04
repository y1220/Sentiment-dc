class AdminController < ApplicationController
  def user_create
    @users = User.all
    @repositories = Repository.all
  end

  def user_update
  end
end
