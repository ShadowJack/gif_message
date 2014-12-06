class HomeController < ApplicationController
  def index
    if params[:viewer_id]
      redirect_to root_url + params[:viewer_id] + '/capture'
    end
  end

end