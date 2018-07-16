class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = t("mailer.activated_warning")
        message += t("mailer.email_activate")
        flash[:warning] = message
        redirect_to home_path
      end
    else
      flash[:danger] = t("application.invalid_login")
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to home_path
  end
end
