require 'test_helper'

class CommitsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get commits_index_url
    assert_response :success
  end

end
