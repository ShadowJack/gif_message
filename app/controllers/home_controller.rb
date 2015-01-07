class HomeController < ApplicationController
  def index
    if params[:viewer_id] && params[:access_token]
      redirect_to root_url + params[:viewer_id] + '/capture?access_token=' + params[:access_token]
    end
  end

end