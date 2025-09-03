class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome back \"#{user.username}!\" You have logged in successfully."
      redirect_to user
    else
      flash.now[:alert] = "Access denied: Invalid email or password. Please try again."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have logged out successfully."
    redirect_to login_path
  end
end
