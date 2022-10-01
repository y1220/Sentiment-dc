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
end
