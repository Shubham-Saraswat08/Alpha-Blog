require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  def setup
    @category1 = Category.create(name: "Isekai")
    @category2 = Category.create(name: "Action")
    @admin_user = User.create(username: "Shubham", email: "ShubhamSaraswat@gmail.com", password: "Shubham", admin: true)
    sign_in_as(@admin_user)
  end
  test "get category form and create category" do
    get "/categories/new"
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
    get "/categories/new"
    assert_response :success
    assert_no_difference "Category.count" do
      post categories_path, params: { category: { name: " " } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
    assert_select "div.alert-danger"
  end

  test "Get element on index" do
    get "/categories"
    assert_select "a[href=?]", category_path(@category1), name: @category1.name.titleize
    assert_select "a[href=?]", category_path(@category2), name: @category2.name.titleize
  end
end
