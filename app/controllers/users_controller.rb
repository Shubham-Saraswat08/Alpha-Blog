class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :block, :unblock ]
  before_action :required_user, except: [ :index, :show, :new, :create ]

  before_action :restrict_blocked_profile_view, only: [ :show ]
  before_action :authorize_user, only: [ :edit, :update ]
  before_action :admin_or_user_delete, only: [ :destroy ]
  before_action :admin_only, only: [ :block, :unblock ]
  before_action :ensure_blocked_user, only: [ :edit, :update, :destroy ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to Alpha Blog #{@user.username}, You have Successfully Signed Up"
      redirect_to users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "#{@user.username} your Profile has been updated Successfully"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 2)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 6)
  end

  def destroy
    if @user.admin? && current_user != @user
      redirect_back fallback_location: users_path, alert: "You cannot delete another admin." and return
    end

    @user.destroy
    session[:user_id] = nil if @user == current_user
    redirect_to users_path, alert: "User #{@user.username} is successfully deleted along with its articles"
  end

  def block
    if @user == current_user
      redirect_back fallback_location: users_path, alert: "You cannot block yourself." and return
    end

    if @user.admin?
      redirect_back fallback_location: users_path, alert: "You cannot block another admin." and return
    end

    if @user.update(is_blocked: true)
      @user.articles.update_all(is_blocked: true)
      redirect_back fallback_location: users_path, alert: "#{@user.username} has been blocked."
    else
      redirect_back fallback_location: users_path, alert: "Failed to block #{@user.username}."
    end
  end

  def unblock
    if @user == current_user
      redirect_back fallback_location: users_path, alert: "You cannot unblock yourself." and return
    end

    if @user.admin?
      redirect_back fallback_location: users_path, alert: "You cannot unblock another admin." and return
    end

    if @user.update(is_blocked: false)
      @user.articles.update_all(is_blocked: false)
      redirect_back fallback_location: users_path, notice: "#{@user.username} has been unblocked."
    else
      redirect_back fallback_location: users_path, alert: "Failed to unblock #{@user.username}."
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def required_user
    unless logged_in?
      redirect_to login_path, alert: "You must be Logged In to perform this action" and return
    end
  end

  def authorize_user
    if @user != current_user
      redirect_to @user, alert: "You are not authorized to perform this action." and return
    end
  end

  def admin_or_user_delete
    if @user.admin? && current_user != @user
      redirect_back fallback_location: users_path, alert: "You cannot delete another admin." and return
    end

    unless current_user == @user || current_user.admin?
      redirect_back fallback_location: users_path, alert: "You are not authorized to perform this action." and return
    end
  end

  def ensure_blocked_user
    if is_blocked
      redirect_to @user, alert: "You are blocked and cannot perform this action" and return
    end
  end

  def admin_only
    unless current_user&.admin?
      redirect_to root_path, alert: "Only admins can perform this action." and return
    end
  end

  def restrict_blocked_profile_view
    if @user.is_blocked && current_user != @user && !current_user&.admin?
      redirect_to users_path, alert: "Only admin and the user themself can see the profile if blocked" and return
    end
  end
end
