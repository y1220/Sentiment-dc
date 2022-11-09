class PropertySettingsController < ApplicationController
  def index
    @company_list=PropertySetting.all.map(&:company).uniq
    @properties= PropertySetting.all
    @id_list= @properties.map(&:id)
  end

  def setup
    @properties= PropertySetting.all
    if !@properties
      # create needes keys for setup
      ['Authorization', 'team_id', 'tasks_space_id', 'gitbranch_field_id', 'availabilities_list_id'].each do |key|
        PropertySetting.create(company: "ClickUp", key_name: key, enabled: true)
      end
      ['repo_name', 'username'].each do |key|
        PropertySetting.create(company: "GitHub", key_name: key, enabled: true)
      end
    end
    @company_list=PropertySetting.all.map(&:company).uniq
    @properties= PropertySetting.all
    @id_list= @properties.map(&:id)
  end

  def edit
    p= PropertySetting.find(params[:id])
    p.key_name = params[:key]
    p.value_text = params[:value]
    if !p.save
      show_error("Something went wrong..try again!","commits/index")
    end
    redirect_to("/property_settings/index")
  end

  def update_key_value
    id= params.keys[2].split(/-/)[2].to_i
    if id!=0
      p= PropertySetting.find(id)
      key_or_value= params.keys[2].split(/-/)[0]
      key_or_value == 'key' ? p.key_name = params[params.keys[2]] : p.value_text = params[params.keys[2]]
      if !p.save
        show_error("Something went wrong..try again!","commits/index")
      end
    end
    redirect_to("/property_settings/index")
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
