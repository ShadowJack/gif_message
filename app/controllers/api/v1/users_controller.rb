require 'net/http/post/multipart'
require 'open-uri'
require 'base64'
require 'net/https'
require 'json'

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
      respond_with :api, :v1, User.create(vk_id: params[:vk_id], gif_length: 2.0, gif_font_color: '#FFF' )
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

  def publish_wall
    found_user = user
    head :forbidden unless found_user
    app = VK::Application.new app_id: APP_ID, access_token: params[:access_token], timeout: 70

    upload_url = app.docs.get_upload_server['upload_url']

    Tempfile.open(['webcam_gif', '.gif'], Dir.tmpdir, 'w+b', :encoding => Encoding::ASCII_8BIT) do |tmp_file|
      image_data = Base64.decode64(params[:image]['data:image/gif;base64,'.length .. -1])
      tmp_file.write(image_data)
      tmp_file.rewind
      puts 'Upload url: ' + upload_url
      RestClient.post upload_url, file: tmp_file do |resp, req, result|
        data = JSON.parse resp
        logger.debug data.inspect
        doc = app.docs.save file: data['file'], title: 'WebCamGif', tags: 'WebCamGif,gif_cam,gif'
        logger.debug doc.inspect
        respond_with doc do |format|
          format.json { render json: doc}
        end
      end
    end
  end

  def publish
    found_user = user
    head :forbidden unless found_user
    app = VK::Application.new app_id: APP_ID, access_token: params[:access_token], timeout: 70

    # get upload url
    upload_url = app.docs.get_upload_server['upload_url']

    Tempfile.create(['webcam_gif', '.gif'], Dir.tmpdir, 'w+b', :encoding => Encoding::ASCII_8BIT) do |tmp_file|
      image_data = Base64.decode64(params[:image]['data:image/gif;base64,'.length .. -1])
      tmp_file.write(image_data)
      tmp_file.rewind
      puts 'Upload url: ' + upload_url
      RestClient.post upload_url, file: tmp_file do |resp, req, result|
        #logger.debug req.inspect
        data = JSON.parse resp
        puts data.inspect
        doc = app.docs.save file: data['file'], title: 'WebCamGif', tags: 'WebCamGif,gif_cam,gif'
        logger.debug doc.inspect
        respond_with doc do |format|
          format.json { render json: doc}
        end
      end
    end
  end

  private
  def user
    #logger.debug 'All params: ' + params.inspect
    User.find_by_vk_id(params[:vk_id])
  end

  def user_params
    params.require('user').permit(:vk_id, :gif_length, :gif_font_color, :upload)
  end
end