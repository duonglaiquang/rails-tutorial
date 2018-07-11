class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t("application.user_error")
    redirect_to home_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:new] = t "users.new.success"
      redirect_to @user
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
