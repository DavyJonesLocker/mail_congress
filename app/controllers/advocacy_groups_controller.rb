class AdvocacyGroupsController < ApplicationController
  def show
    @advocacy_group = current_advocacy_group
  end

  def new
    @advocacy_group = AdvocacyGroup.new
  end

  def create
    @advocacy_group = AdvocacyGroup.new(params[:advocacy_group])
    
    if @advocacy_group.save
      AdvocacyGroupMailer.confirmation_process(@advocacy_group).deliver
      AdminMailer.new_advocacy_group(@advocacy_group).deliver
      redirect_to root_path, :notice => 'Thank you, we will be in contact shortly'
    else
      render :action => :new
    end
  end
end
