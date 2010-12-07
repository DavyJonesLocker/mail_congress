class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.valid?
      @feedback.mail
      redirect_to root_path, :notice => 'Thank you for your feedback!'
    else
      render :action => :new
    end
  end
end
