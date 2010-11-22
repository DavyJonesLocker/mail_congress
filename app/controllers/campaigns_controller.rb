class CampaignsController < ApplicationController
  def show
    @campaign = Campaign.find(params[:id])
    render :template => 'home/index'
  end
end
