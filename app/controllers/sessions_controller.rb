class SessionsController < ApplicationController

  before_action :protect_login

  def new
    @user = User.new
    render :new
  end

  def create
    login_user!
    redirect_to "/cats"
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to '/session/new'
  end

  private
  def protect_login
    redirect_to '/cats' if (logged_in? && request.get?)
  end

end
