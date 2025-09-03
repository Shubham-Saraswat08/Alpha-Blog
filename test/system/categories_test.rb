require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  setup do
    @admin_user = users(:one)
    @category = Category.create!(name: "Sample Category")
  end

  def sign_in_as(user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_on "Login"
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Categories"
  end

  test "should create category as admin" do
    sign_in_as(@admin_user)
    visit new_category_url
    fill_in "Category Name", with: "New Category"
    click_on "Create Category"
    assert_selector ".toast", text: "Category created successfully."
  end

  test "should update category as admin" do
    sign_in_as(@admin_user)
    visit edit_category_url(@category)
    fill_in "Category Name", with: "Updated Category"
    click_on "Update Category"
    assert_selector ".toast", text: "Category updated successfully."
  end
end
