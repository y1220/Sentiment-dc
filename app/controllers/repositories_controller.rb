class RepositoriesController < ApplicationController
  def index
    @repository = Repository.new
    @repositories = Repository.all
  end

  def create
    @repository = Repository.new(title: params['title'], owner: params['owner'], description: params['description'])
    if @repository.save
      flash[:notice]= "Saving repository: #{@repository.title} has been success!"
      redirect_to("/repositories/index")
    else
      show_error("Something went wrong..try again!","repositories/index")
    end
  end

  def edit
    @repository = Repository.find(params[:id])
    if @repository.update(title: params['title'], owner: params['owner'], description: params['description'])
      flash[:notice]= "Updating repository: #{@repository.title} has been success!"
      redirect_to("/repositories/index")
    else
      show_error("Something went wrong..try again!","repositories/index")
    end
  end

  def delete
    @repository = Repository.find(params[:id])
    title = @repository.title
    if @repository.delete
      flash[:notice]= "Deleting repository: #{title} has done!"
      redirect_to("/repositories/index")
    else
      show_error("Something went wrong..try again!","repositories/index")
    end
  end

  private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end
end
