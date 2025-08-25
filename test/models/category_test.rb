require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = Category.new(name: "Sports")
  end
  test "Category Should be valid" do
    assert @category.valid?
  end

  test "Category Should be Present" do
    @category.name = ""
    assert_not @category.valid?
  end

  test "Category should be Unique" do
    @category.save
    @category2 = Category.new(name: "Sports")
    assert_not @category2.valid?
  end

  test "Category name should not too long" do
    @category.name = "a" * 30
    assert_not @category.valid?
  end

  test "Category name should not be too small" do
    @category.name = "aa"
    assert_not @category.valid?
  end
end
