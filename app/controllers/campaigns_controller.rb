class CampaignsController < ApplicationController
  prepend_before_filter :authenticate_advocacy_group!
  before_filter :define_advocacy_group
  before_filter :find_campaign, :only => [:show, :edit, :update]

  def new
    @campaign = @advocacy_group.campaigns.build
  end

  def create
    @campaign = @advocacy_group.campaigns.build(params[:campaign])
    if @campaign.save
      redirect_to @campaign
    else
      render :action => :new
    end
  end

  def update
    if @campaign.update_attributes(params[:campaign])
      redirect_to @campaign, :notice => "#{@campaign.title} has been updated."
    else
      render :action => :edit
    end
  end

  private

  def define_advocacy_group
    @advocacy_group = current_advocacy_group
  end

  def find_campaign
    @campaign = @advocacy_group.campaigns.find(params[:id])
  end
end
