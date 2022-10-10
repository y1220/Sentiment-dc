class PropertySettingsController < ApplicationController
  def index
    @company_list=PropertySetting.all.map(&:company).uniq
    @properties = PropertySetting.all
  end
end
