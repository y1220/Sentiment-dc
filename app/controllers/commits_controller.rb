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

  def order_detail
    @order = Order.new
      @order.assign_attributes(username: params[:customer_name], email: params[:email], password: params[:customer_password])
       if /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.match(params[:email])
         if /^[a-zA-Z0-9_.+-]{4,8}$/.match(params[:customer_password])
           if @customer.save
             session[:customer_id]=@customer.id
             flash[:notice]= "Thank you for the registration!"
             redirect_to("/customers/personal/#{@customer.id}")
           else
             show_error("Something went wrong..try again!","customers/new")
           end
         else
           show_error("Inserted password is not valid..try again!","customers/new")
         end
       else
         show_error("Inserted email is not valid..try again!","customers/new")
       end
  end

  private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end
end
