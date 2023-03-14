class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end
end
