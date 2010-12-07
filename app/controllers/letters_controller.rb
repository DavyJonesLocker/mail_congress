class LettersController < ApplicationController
  def show
    letter = Letter.new(params[:letter])
    render :text => letter.to_png
  end

  def create
    Letter.create_from_redis(params[:redis_key])
    redirect_to thank_you_path
  end

  def destroy
    Redis.new.del(params[:redis_key])
  end
end
