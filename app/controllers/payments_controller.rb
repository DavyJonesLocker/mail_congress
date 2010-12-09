class PaymentsController < ApplicationController
  def new
    @letter = Letter.new(params[:letter])
    @geoloc = GeoKit::GeoLoc.new(params[:geoloc])
    @geoloc.state   = @letter.sender.state
    @geoloc.success = true

    if @letter.valid?
      @payment = @letter.sender.build_payment
    else
      @letter.build_recipients(@geoloc)
      render :template => 'search/show'
    end
  end

  def create
    @letter  = Letter.new(params[:letter])
    @payment = Payment.new(params[:payment])

    if @payment.make(@letter, payment_options)
      unless @letter.payment_type == 'paypal'
        @letter.generate_follow_up_id!
        @letter.save
        PrintJob.enqueue(@letter)
      end
      redirect_to @payment.url || thank_you_path
    else
      render 'new'
    end
  end

  def complete
    letter = Letter.get_from_redis(params[:redis_key])
    paypal_response = Payment.complete(letter.cost, 
      :ip => request.headers["REMOTE_ADDR"],
      :payer_id => params[:PayerID],
      :token => params[:token])

    if paypal_response.success?
      letter.generate_follow_up_id!
      letter.save
      PrintJob.enqueue(letter)
      redirect_to thank_you_path
    else
      redirect_to destroy_letter_path(params[:redis_key]), :notice => paypal_response.message
    end
  end

  def destroy
    Redis.new.del(params[:redis_key])
  end

  private

  def payment_options
    {
      :ip => request.headers["REMOTE_ADDR"],
      :payments_url => payments_url
    }
  end

end
