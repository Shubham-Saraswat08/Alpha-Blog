class CategoriesController < ApplicationController
  before_action :require_admin, except: [ :index, :show ]
  def index
    @categories = Category.all
  end
  def show
    @category = Category.find(params[:id])
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
      render :new
    end
  end

  private
  def require_admin
    if !(logged_in? && current_user.admin?)
      redirect_to categories_path, alert: "You are not authorized to perform this action."
    end
  end
end
