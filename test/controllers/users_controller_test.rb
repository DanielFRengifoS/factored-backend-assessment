require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get post" do
    get users_post_url
    assert_response :success
  end

  test "should get get" do
    get users_get_url
    assert_response :success
  end
end
