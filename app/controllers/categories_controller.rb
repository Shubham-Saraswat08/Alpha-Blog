class CategoriesController < ApplicationController
  def index
  end
  def show
  end
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))
    if @category.save
      flash[:notice] = "Category created Successfully"
      redirect_to category_path(@category)
    else
      render :new, status: :unprocessable_entity
    end
  end
end
