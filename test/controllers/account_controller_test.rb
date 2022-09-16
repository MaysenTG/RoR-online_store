require "test_helper"

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get account_show_url
    assert_response :success
  end

  test "should get all" do
    get account_all_url
    assert_response :success
  end

  test "should get edit" do
    get account_edit_url
    assert_response :success
  end
end
