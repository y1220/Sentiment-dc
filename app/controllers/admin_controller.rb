class AdminController < ApplicationController


  include HTTParty
  base_uri "https://api.github.com/repos"

  def user_create
    @users = User.all
    @repositories = Repository.all
  end

  def user_update
    repo = Repository.find(params['id'])
    if !repo
      show_error("Something went wrong..try again!","admin/user_create")
    end
    response = Repository.contributors(params['id'])
    response.each do |contributor|
      username = contributor['login']
      gid = contributor['id']
      user = User.where(gid: contributor['id'])
      if user.count != 0
        if !repo.users.map(&:gid).include? contributor['id']
          repo.users << user
        end
      else
        user = User.new(git_username: username, gid: gid)
        if user.save
          repo.users << user
          flash[:notice]= "Saving new user has been success!"
        else
          show_error("Something went wrong..try again!","admin/user_create")
        end
      end
    end
    redirect_to("/admin/user_create")
  end

end
