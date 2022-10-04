class CommitsController < ApplicationController

  def index
    @tasks = Task.parent_list
    Task.update if @tasks.empty?
  end

  def update_github
    Commit.update
    @tasks = Task.parent_list
    redirect_to action: "index"
  end

  def update_link
    @branches = Branch.all
  end

  def show_task_commit
    # GET
    @task = Task.where(cid: params[:cid]).first
    @branches = Branch.all
  end

  def task_registration
    # GET
    @task = Task.where(cid: params[:cid]).first
    @branches = Branch.all
  end

  def register_task_commit
    # POST
    params.keys.select{|x| x.start_with?("cmt")}.each do |commit|
      c_sep = commit.split(/-/)
      cid = c_sep[1]
      tid = c_sep[2]
      c = Commit.find(cid.to_i)
      c.task_id = tid
      if !c.save
        show_error("Something went wrong..try again!","commits/index")
      end
    end

    @tasks = Task.parent_list
    redirect_to action: "index"
  end

  def assign_git
    @branches = Branch.all
    @task = Task.where(cid: params['cid'])[0]
  end

  private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end
end
