require 'test_helper'

class NotionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notion_index_url
    assert_response :success
  end

end
