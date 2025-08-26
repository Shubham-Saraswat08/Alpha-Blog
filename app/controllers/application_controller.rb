class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?, :color_for_category

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def accent_colors
    [ "#f94144", "#f3722c", "#f9c74f", "#90be6d", "#577590", "#277da1", "#4d908e", "#f9844a", "#43aa8b", "#bc5090" ]
  end

  def color_for_category(category)
    colors = accent_colors
    return "#4a90e2" if category.nil? || colors.empty?

    colors[category.id % colors.length]
  end
end
