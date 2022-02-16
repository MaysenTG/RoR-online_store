require "test_helper"

class ShopsCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get Index" do
    get shops_categories_Index_url
    assert_response :success
  end

  test "should get Show" do
    get shops_categories_Show_url
    assert_response :success
  end
end
