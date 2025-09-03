class LikesController < ApplicationController
  before_action :set_article, only: [ :create, :destroy ]
  before_action :require_login, only: [ :create, :destroy ]
  before_action :current_user_is_blocked, only: [ :create, :destroy ]
  before_action :ensure_blocked_article_or_user, only: [ :create, :destroy ]

  def create
    @like = current_user.likes.new(article: @article)

    if @like.save
      redirect_back fallback_location: @article, notice: "You liked this article \"#{@article.title}\"."
    else
      redirect_back fallback_location: articles_path, alert: "Sorry, we couldn't process your like. Please try again."
    end
  end


  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    redirect_back fallback_location: @article, notice: "You removed your like from this article \"#{@article.title}\"."
  end

  private

  def like_params
    params.require(:likes).permit(:article_id)
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def current_user_is_blocked
    if current_user.is_blocked
      redirect_back fallback_location: articles_path, alert: "Access denied: You are blocked and cannot like or dislike articles."
    end
  end

  def ensure_blocked_article_or_user
    if @article.is_blocked || @article.user.is_blocked
      message = if @article.user.is_blocked
        "Access denied: The author of this article is blocked."
      else
        "Access denied: This article is blocked."
      end
      redirect_back fallback_location: @article.user, alert: message
    end
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Access denied: You must be logged in to perform this action." and return
    end
  end
end
