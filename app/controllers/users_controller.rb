class UsersController < ApplicationController

before_action :protect_signup

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user!
      redirect_to '/cats'
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end

  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def protect_signup
    redirect_to '/cats' if (logged_in? && request.get?)
  end

end
