class PasswordResetsController < ApplicationController
  before_action :get_user, :check_expiration, :valid_user, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.info"
      redirect_to home_path
    else
      flash.now[:danger] = t "password_resets.invalid_email"
      render :new
    end
  end

  def update
    if params[:user][:password].present?
      if @user.update_attributes user_params
        log_in @user
        @user.update_attributes reset_digest: nil
        flash[:success] = t("password_resets.success")
        redirect_to @user
      else
        render :edit
      end
    else
      @user.errors.add :password, t("password_resets.pw_empty_alert")
      render :edit
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    redirect_to home_path, alert: t("application.failed") if @user.nil?
  end

  def valid_user
    unless @user&.activated? &&
           @user.authenticated?(:reset, params[:id])
      redirect_to home_path, alert: t("application.failed")
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: t("password_resets.expired")
    end
  end
end
