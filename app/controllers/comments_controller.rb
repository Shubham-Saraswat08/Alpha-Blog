class CommentsController < ApplicationController
  before_action :article_params, only: [ :index, :create, :destroy ]
  before_action :required_login, only: [ :create, :destroy ]
  before_action :current_user_is_blocked, only: [ :create, :destroy ]
  before_action :verify_blocked, only: [ :create, :destroy ]

  def index
    @comments = @article.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to article_comments_path(@article), notice: "Your comment has been posted!"
    else
      @comments = @article.comments.order(created_at: :desc)
      flash[:comment_errors] = @comment.errors.full_messages
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @article.comments.find(params[:id])

    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      flash[:notice] = "Your comment has been deleted."
    else
      flash[:alert] = "Access denied: You are not authorized to delete this comment."
    end

    redirect_to article_comments_path(@article)
  end

  private

  def article_params
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def required_login
    unless logged_in?
      redirect_back fallback_location: articles_path, alert: "Access denied: You must be logged in to perform this action."
    end
  end

  def current_user_is_blocked
    if current_user.is_blocked
      redirect_back fallback_location: articles_path, alert: "Access denied: You are blocked and cannot add or delete comments."
    end
  end

  def verify_blocked
    if @article.is_blocked || @article.user.is_blocked
      message = if @article.user.is_blocked
        "Access denied: The author of this article is blocked."
      else
        "Access denied: This article is blocked."
      end
      redirect_back fallback_location: @article.user, alert: message
    end
  end
end
