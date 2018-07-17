class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t "microposts.create_success"
      redirect_to home_path
    else
      feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t "microposts.delete_success"
    redirect_to request.referrer || home_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to home_path if @micropost.nil?
  end
end
