class Api::V1::UsersController < ApplicationController
  respond_to :json

  def index
    respond_with User.all
  end

  def show
    found_user = user
    if found_user
      respond_with found_user
    else
      respond_with :api, :v1, User.create(vk_id: params[:vk_id], gif_length: 2.0, gif_font_color: '#FFF')
    end
  end

  def create
    logger.debug user_params[:vk_id]
    respond_with :api, :v1, User.create(user_params)
  end

  def update
    respond_with user.update(user_params)
  end

  def destroy
    respond_with user.destroy
  end

  private
  def user
    logger.debug 'All params: ' + params.inspect
    User.find_by_vk_id(params[:vk_id])
  end

  def user_params
    params.require('user').permit(:vk_id, :gif_length, :gif_font_color)
  end
end