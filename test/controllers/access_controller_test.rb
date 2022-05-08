require "test_helper"

class AccessControllerTest < ActionDispatch::IntegrationTest
  test "should get register" do
    get access_register_url
    assert_response :success
  end
end
