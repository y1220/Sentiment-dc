require 'test_helper'

class GitIssuesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get git_issues_index_url
    assert_response :success
  end

end
