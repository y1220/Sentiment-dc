class PropertySettingsController < ApplicationController
  def index
    @properties = PropertySetting.all
  end
end
