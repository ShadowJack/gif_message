class Api::V1::GifsController < ApplicationController
  respond_to :json
  before_filter :get_user

  def get_user
    @user = User.find_by_vk_id(params[:user_id])
  end

  def index
    respond_with @user.gifs
  end

  def show
    respond_with gif
  end

  def create
    respond_with :api, :v1, @user.gifs.create(gif_params)
  end

  def update
    respond_with gif.update(gif_params)
  end

  def destroy
    respond_with gif.destroy
  end

  private
  def gif
    @user.gifs.find(params[:id])
  end

  def gif_params
    params.require(:user)
    params.require(:gif).permit(:title, :vk_url)
  end
end