class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #
  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
  #
  def login_user!
    @user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )
    session[:session_token] = @user.session_token
  end

  # def require_login!
  # end

  def logged_in?
    !current_user.nil?
  end

  helper_method :current_user
end
