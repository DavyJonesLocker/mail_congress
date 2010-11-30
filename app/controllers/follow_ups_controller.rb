class FollowUpsController < ApplicationController
  def show
    @letter = Letter.find_by_follow_up_id(params[:id])
    @letter.update_attribute(:follow_up_made, true)
  end
end
