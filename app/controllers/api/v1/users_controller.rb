class Api::V1::UsersController < ApplicationController
  respond_to :json

  def index
    respond_with User.all
  end

  def show
    respond_with user
  end

  # when we create new user we get vk_id from :id field
  def create
    logger.debug user_params[:vk_id]
    respond_with :api, :v1, User.create(user_params)
  end

  # when we update user we get vk_id from :id field
  # and set new value from :vk_id
  def update
    respond_with user.update(user_params)
  end

  def destroy
    respond_with user.destroy
  end

  private
  # :id is gotten form path - it equals to vk_id
  def user
    User.find_by_vk_id(params[:id])
  end

  def user_params
    params.require('user').permit(:id, :vk_id, :gif_length, :gif_font_color)
  end
end