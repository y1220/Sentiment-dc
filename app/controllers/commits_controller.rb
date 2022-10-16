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
    c_list=[]
    params.keys.select{|x| x.start_with?("cmt")}.each do |commit|
      c_sep = commit.split(/-/)
      cid = c_sep[1]
      tid = c_sep[2]
      c = Commit.find(cid.to_i)
      c.task_id = tid
      if !c.save
        show_error("Something went wrong..try again!","commits/index")
      end
      c_list << cid.to_i
    end
    # check if task has additional commits which were not selected by user -> delete them
    tid = Commit.find(c_list[0]).task_id
    c_list_db = Commit.where(task_id: tid).map(&:id)

    if (c_list.sort != c_list_db.sort)
      diff = c_list_db - c_list
      diff.each do |cid|
        c = Commit.find(cid)
        c.task_id = nil
        if !c.save
          show_error("Something went wrong..try again!","commits/index")
        end
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
