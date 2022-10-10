require 'test_helper'

class PropertySettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get property_settings_index_url
    assert_response :success
  end

end
