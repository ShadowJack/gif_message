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
      respond_with :api, :v1, User.create(vk_id: params[:vk_id], gif_length: 2.0, gif_font_color: '#FFF', album_id: '')
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

  def upload_wall
    found_user = user
    head :forbidden unless found_user
    app = VK::Application.new app_id: APP_ID, access_token: params[:access_token], timeout: 70

    Tempfile.create(['gif_cam', '.gif'], Dir.tmpdir, 'w+b', :encoding => Encoding::ASCII_8BIT) do |tmp_file|
      image_data = Base64.decode64(params[:image]['data:image/gif;base64,'.length .. -1])
      tmp_file.write(image_data)
      tmp_file.rewind
      puts 'Upload url: ' + params[:upload_url]
      RestClient.post params[:upload_url], photo: tmp_file do |resp, req, result|
        #logger.debug req.inspect
        data = JSON.parse resp
        #puts data.inspect
        photo = app.photos.save_wall_photo photo: data['photo'], server: data['server'], hash: data['hash']
        logger.debug photo.inspect
        respond_with photo do |format|
          format.json { render json: photo}
        end
      end
    end
  end

  def upload_album
    found_user = user
    head :forbidden unless found_user
    app = VK::Application.new app_id: APP_ID, access_token: params[:access_token], timeout: 70

    #check if current user has active album
    if found_user.album_id == nil || found_user.album_id == ''
      created_album = app.photos.create_album title: 'GifCam',
                                              description: 'Gifки созданные в приложении GifCam',
                                              privacy: 3,  # only me
                                              comment_privacy: 0  # everyone
      # puts created_album.inspect
      found_user.update album_id: created_album['id']
    end

    # get upload url
    upload_url = app.photos.get_upload_server(album_id: found_user.album_id)['upload_url']

    Tempfile.create(['gif_cam', '.gif'], Dir.tmpdir, 'w+b', :encoding => Encoding::ASCII_8BIT) do |tmp_file|
      image_data = Base64.decode64(params[:image]['data:image/gif;base64,'.length .. -1])
      tmp_file.write(image_data)
      tmp_file.rewind
      puts 'Upload url: ' + upload_url
      RestClient.post upload_url, file1: tmp_file do |resp, req, result|
        #logger.debug req.inspect
        data = JSON.parse resp
        puts data.inspect
        photo = app.photos.save photos_list: data['photos_list'], server: data['server'], hash: data['hash'], album_id: data['aid']
        logger.debug photo.inspect
        respond_with photo do |format|
          format.json { render json: photo}
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
    params.require('user').permit(:vk_id, :gif_length, :gif_font_color, :upload, :album_id)
  end
end