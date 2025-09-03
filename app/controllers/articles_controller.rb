class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy, :block, :unblock ]
  before_action :required_user, except: [ :index, :show ]

  before_action :restrict_blocked_view, only: [ :show ]
  before_action :authorize_edit_update, only: [ :edit, :update ]
  before_action :authorize_destroy, only: [ :destroy ]
  before_action :admin_only, only: [ :block, :unblock ]
  before_action :ensure_blocked_user, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :ensure_blocked_article, only: [ :edit, :update, :destroy ]

  def home
    redirect_to articles_path if logged_in?
  end

  def about
  end
  def index
    if current_user&.admin?
      @articles = Article.paginate(page: params[:page], per_page: 4)
    else
      @articles = Article.where(is_blocked: false).paginate(page: params[:page], per_page: 4)
    end
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = "Article created successfully."
      redirect_back fallback_location: article_path(@article)
    else
      flash.now[:validation_errors] = @article.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article updated successfully."
    else
      flash.now[:validation_errors] = @article.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_back fallback_location: articles_path, notice: "The article titled “#{@article.title}” has been deleted."
  end

  def block
    if @article.user.is_blocked?
      redirect_back fallback_location: @article, alert: "Cannot block this article because the author's profile (#{@article.user.username}) is already blocked."
      return
    end

    if @article.update(is_blocked: true)
      redirect_back fallback_location: articles_path, notice: "The article “#{@article.title}” by #{@article.user.username} has been blocked."
    else
      redirect_back fallback_location: articles_path, alert: "Failed to block the article “#{@article.title}”."
    end
  end

  def unblock
    if @article.user.is_blocked?
      redirect_back fallback_location: @article, alert: "Cannot unblock this article because the author's profile (#{@article.user.username}) is still blocked."
      return
    end

    if @article.update(is_blocked: false)
      redirect_back fallback_location: articles_path, notice: "The article “#{@article.title}” by #{@article.user.username} has been unblocked."
    else
      redirect_back fallback_location: articles_path, alert: "Failed to unblock the article “#{@article.title}”."
    end
  end



  private

  def set_article
    @article = Article.find(params[:id])
  end

  def required_user
    unless logged_in?
      redirect_to login_path, alert: "Access Denied: Please log in to continue."
    end
  end

  def authorize_edit_update
    if current_user != @article.user
      redirect_to @article, alert: "Access Denied: You don’t have permission to edit this article."
    end
  end

  def authorize_destroy
    unless current_user == @article.user || current_user.admin?
      redirect_to @article, alert: "Access Denied: Only the article owner or an admin can delete it."
    end
  end

  def admin_only
    unless current_user.admin?
      redirect_to @article, alert: "Access Denied: This action is restricted to admins."
    end
  end

  def ensure_blocked_user
    if is_blocked
      redirect_back fallback_location: current_user, alert: "Access Denied: Your account is blocked and cannot perform this action."
    end
  end

  def ensure_blocked_article
    if @article.is_blocked
      redirect_back fallback_location: current_user, alert: "Access Denied: This article is blocked and cannot be modified."
    end
  end

  def restrict_blocked_view
    if @article.user != current_user && !current_user.admin? && @article.is_blocked
      redirect_to articles_path, alert: "Access Denied: You’re not allowed to view blocked articles."
    end
  end

  def article_params
    params.require(:article).permit(:title, :content, category_ids: [])
  end
end
