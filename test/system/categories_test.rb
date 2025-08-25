require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  setup do
    @category = Category.create!(name: "Sample Category")
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Categories"
  end

  test "should create category" do
    visit categories_url
    click_on "New Category" # Usually capitalization matters for button/link text

    fill_in "Name", with: "New Category" # Add filling in required fields

    click_on "Create Category"

    assert_text "Category was successfully created"
    click_on "Back"
  end

  test "should update category" do
    visit category_url(@category)
    click_on "Edit this category", match: :first

    fill_in "Name", with: "Updated Category" # Change something to trigger update
    click_on "Update Category"

    assert_text "Category was successfully updated"
    click_on "Back"
  end

  test "should destroy category" do
    visit category_url(@category)
    accept_confirm do
      click_on "Destroy this category", match: :first
    end

    assert_text "Category was successfully destroyed"
  end
end
