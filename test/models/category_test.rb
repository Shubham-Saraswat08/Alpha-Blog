require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = Category.new(name: "Gaming")  # Use a unique name not in fixtures
  end

  test "category should be valid" do
    assert @category.valid?
  end

  test "name should be present" do
    @category.name = ""
    assert_not @category.valid?
  end

  test "name should be unique" do
    duplicate_category = Category.new(name: categories(:one).name)
    assert_not duplicate_category.valid?
  end
end
