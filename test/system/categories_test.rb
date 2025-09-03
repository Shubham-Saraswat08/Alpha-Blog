require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  setup do
    # You can create a category directly in the setup
    @category = Category.create!(name: "Sample Category")
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Categories"
  end

  test "should create category" do
    visit new_category_url

    # Use the exact label text "Category Name" in the form
    fill_in "Category Name", with: "New Category"  # Corrected label
    click_on "Create Category"

    assert_text "Category was successfully created"
    click_on "Back"  # Correcting the back button label to match your test
  end

  test "should update category" do
    visit category_url(@category)

    find('a[title="Edit"]').click

    fill_in "Category Name", with: "Updated Category"
    click_on "Update Category"

    assert_text "Category was successfully updated"
    click_on "Back"
  end



  # test "should destroy category" do
  #   visit category_url(@category)
  #   accept_confirm do
  #     click_on "Destroy this category", match: :first
  #   end

  #   assert_text "Category was successfully destroyed"
  # end
end
