class AdminController < ApplicationController
  def user_create
    @users = User.all
  end
end
