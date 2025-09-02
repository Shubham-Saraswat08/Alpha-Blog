class CategoriesController < ApplicationController
  before_action :require_admin, except: [ :index, :show ]
  def index
    @categories = Category.all.paginate(page: params[:page], per_page: 26)
  end
  def show
    @category = Category.find(params[:id])
    if current_user.admin?
      @categories_article = @category.articles.paginate(page: params[:page], per_page: 2)
    else
      @categories_article = @category.articles.where(is_blocked: false).paginate(page: params[:page], per_page: 2)
    end
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

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(params.require(:category).permit(:name))
      redirect_to @category, notice: "Category Updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def require_admin
    if !(logged_in? && current_user.admin?)
      redirect_to categories_path, alert: "You are not authorized to perform this action."
    end
  end
end
