require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get user_create" do
    get admin_user_create_url
    assert_response :success
  end

end
