class BranchesController < ApplicationController

    def update_git_url
        @branches = Branch.all
        @branches.each do |branch|
          if params[:"url#{branch.name}-#{branch.id}"]
            branch.url = params[:"url#{branch.name}-#{branch.id}"]
            if branch.save
              flash[:notice]= "Saving git link has been success!"
              redirect_to("/commits/update_link")
            else
              show_error("Something went wrong..try again!","commits/update_link")
            end
          end
        end
    end

    def register_git_branch
      # POST
      byebug
      branch_id = params[:branch_task].split(/-/)[0]
      task_id = params[:branch_task].split(/-/)[1]
      t = Task.find(task_id.to_i)
      t.branch_id = branch_id
      if t.save
        flash[:notice]= "Saving git branch to the task: #{t.cid} has been success!"
        redirect_to("/commits/index")
      else
        show_error("Something went wrong..try again!","commits/assign_git/#{task_id}")
      end
    end

    private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end
end
