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
    if current_user.admin?
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
      flash[:notice] = "Article created Successfully"
      redirect_back fallback_location: article_path(@article)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_back fallback_location: @article, notice: "Article Updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_back fallback_location: articles_path, alert: "Article #{@article.title} has been successfully deleted."
  end

  def block
    if @article.user.is_blocked?
      redirect_back fallback_location: @article, alert: "'#{@article.title}' can't be blocked because #{@article.user.username}'s profile is blocked."
      return
    end

    if @article.update(is_blocked: true)
      redirect_back fallback_location: articles_path, notice: "'#{@article.title}' by #{@article.user.username} has been blocked."
    else
      redirect_back fallback_location: articles_path, alert: "Failed to block '#{@article.title}' by #{@article.user.username}."
    end
  end

  def unblock
    if @article.user.is_blocked?
      redirect_back fallback_location: @article, alert: "'#{@article.title}' can't be unblocked because #{@article.user.username}'s profile is currently blocked."
      return
    end

    if @article.update(is_blocked: false)
      redirect_back fallback_location: articles_path, notice: "'#{@article.title}' by #{@article.user.username} has been unblocked."
    else
      redirect_back fallback_location: articles_path, alert: "Failed to unblock '#{@article.title}' by #{@article.user.username}."
    end
  end


  private

  def set_article
    @article = Article.find(params[:id])
  end

  def required_user
    unless logged_in?
      redirect_to login_path, alert: "You must be Logged In to perform this action"
    end
  end

  def authorize_edit_update
    if current_user != @article.user
      redirect_to @article, alert: "You are not authorized to perform this action."
    end
  end

  def authorize_destroy
    unless current_user == @article.user || current_user.admin?
      redirect_to @article, alert: "Only the owner or an admin can delete this article."
    end
  end

  def admin_only
    if !current_user.admin?
      redirect_to @article, alert: "Only Admin are authorized to perform this action."
    end
  end

  def ensure_blocked_user
    if is_blocked
      redirect_back fallback_location: current_user, alert: "You are blocked and cannot perform this action"
    end
  end

  def ensure_blocked_article
    if @article.is_blocked
      redirect_back fallback_location: current_user, alert: "This article is blocked thus you cant edit, update or destroy this article"
    end
  end

  def article_params
    params.require(:article).permit(:title, :content, category_ids: [])
  end

  def restrict_blocked_view
    if @article.user != current_user && !current_user.admin? && @article.is_blocked
      redirect_to articles_path, alert: "Only admin and the user themself can see the blocked articles"
    end
  end
end
