class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :required_user, except: [ :index, :show ]
  before_action :authorize_article, only: [ :edit, :update, :destroy ]

  def home
    redirect_to articles_path if logged_in?
  end

  def about
  end
  def index
    @articles = Article.paginate(page: params[:page], per_page: 6)
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
      redirect_to article_path(@article)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article Updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article deleted successfully."
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

def authorize_article
  unless @article.user == current_user
    redirect_to @article, alert: "You are not authorized to perform this action."
  end
end

def article_params
  params.require(:article).permit(:title, :description)
end
