class LettersController < ApplicationController
  def show
    letter = Letter.new(params[:letter])
    render :text => letter.to_png
  end

  def create
    debugger
    letter = Letter.get_from_redis(params[:redis_key])
    paypal_response = Payment.complete(letter.cost, 
      :ip => request.headers["REMOTE_ADDR"],
      :payer_id => params[:PayerID],
      :token => params[:token])

    if paypal_response.success?
      redirect_to thank_you_path
    else
      redirect_to destroy_letter_path(params[:redis_key]), :notice => paypal_response.message
    end
  end

  def destroy
    Redis.new.del(params[:redis_key])
  end
end
