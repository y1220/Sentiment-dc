class PropertySettingsController < ApplicationController
  def index
    @company_list=PropertySetting.all.map(&:company).uniq
    @properties= PropertySetting.all
    @id_list= @properties.map(&:id)
  end

  def disable_record
    p= PropertySetting.find(params[:id].to_i)
    p.enabled= false
    if !p.save
      show_error("Something went wrong..try again!","commits/index")
    end
    redirect_to("/property_settings/index")
  end

  def enable_record
    p= PropertySetting.find(params[:id].to_i)
    p.enabled= true
    if !p.save
      show_error("Something went wrong..try again!","commits/index")
    end
    redirect_to("/property_settings/index")
  end

  private
  def show_error (error_message, return_to_address)
    flash[:notice]= error_message
    render(return_to_address)
  end
end
