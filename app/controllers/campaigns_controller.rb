class CampaignsController < ApplicationController
  before_filter :define_advocacy_group
  def show
    @campaign = @advocacy_group.campaigns.find(params[:id])
  end

  def new
    @campaign = @advocacy_group.campaigns.build
  end

  def create
    @campaign = @advocacy_group.campaigns.create(params[:campaign])
    redirect_to @campaign
  end

  private

  def define_advocacy_group
    @advocacy_group = current_advocacy_group
  end
end
