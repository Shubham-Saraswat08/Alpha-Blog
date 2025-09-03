require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  def setup
    @category1 = Category.create(name: "Isekai")
    @category2 = Category.create(name: "Action")
    @admin_user = User.create(
      username: "Shubham",
      email: "ShubhamSaraswat@gmail.com",
      password: "Shubham",
      admin: true
    )
    sign_in_as(@admin_user)
  end

  test "get category form and create category" do
    get new_category_path
    assert_response :success

    assert_difference "Category.count", 1 do
      post categories_path, params: { category: { name: "Sport" } }
      assert_response :redirect
    end

    follow_redirect!
    assert_response :success
    assert_match "Sport", response.body
  end

  test "get new category form and reject invalid category" do
    get new_category_path
    assert_response :success

    assert_no_difference "Category.count" do
      post categories_path, params: { category: { name: " " } }
    end

    assert_response :unprocessable_content

    # ✅ Updated selectors to match Bootstrap toast-based validation errors
    assert_select "div.toast-container"
    assert_select "div.toast-body"
    assert_select "strong", text: /Validation_errors/i
    assert_select "ul > li", text: "Name can't be blank"
  end

  test "get categories index and check for category links" do
    get categories_path
    assert_response :success

    assert_select "a[href=?]", category_path(@category1), text: @category1.name.titleize
    assert_select "a[href=?]", category_path(@category2), text: @category2.name.titleize
  end
end
