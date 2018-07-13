class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def show
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
      log_in @user
      flash[:new] = t "users.new.success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit;
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t("application.profile_updated")
      redirect_to @user
    else
      render :edit
    end
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def destroy
    if @user.destroy.destroyed?
      flash[:success] = t("application.delete_success")
    else
      flash[:danger] = t("application.failed")
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t("application.please_login")
    redirect_to login_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(home_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(home_path) unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    redirect_to home_path, alert: t("application.failed") if @user.nil?
  end
end
