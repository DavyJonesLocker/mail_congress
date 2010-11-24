class HomeController < ApplicationController
  respond_to :html

  def index
    if params[:campaign_id]
      @campaign = Campaign.find(params[:campaign_id])
    end
  end
end
