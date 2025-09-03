require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
    @admin_user = users(:one)  # admin user fixture
  end

  # Helper to simulate logging in a user via the login path
  def sign_in_as(user, password: "password")
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    sign_in_as(@admin_user)
    assert_difference("Category.count", 1) do
      post categories_url, params: { category: { name: "Travel" } }
    end

    assert_redirected_to category_url(Category.last)
  end

  test "should not create category if not admin" do
    # No login here means unauthorized user
    assert_no_difference("Category.count") do
      post categories_url, params: { category: { name: "Travel" } }
    end

    assert_redirected_to categories_path
  end

  test "should show category" do
    get category_url(@category)
    assert_response :success
  end

  # Uncomment and complete when you add those actions
  # test "should get edit" do
  #   sign_in_as(@admin_user)
  #   get edit_category_url(@category)
  #   assert_response :success
  # end

  # test "should update category" do
  #   sign_in_as(@admin_user)
  #   patch category_url(@category), params: { category: { name: "Updated Name" } }
  #   assert_redirected_to category_url(@category)
  # end

  # test "should destroy category" do
  #   sign_in_as(@admin_user)
  #   assert_difference("Category.count", -1) do
  #     delete category_url(@category)
  #   end

  #   assert_redirected_to categories_url
  # end
end
