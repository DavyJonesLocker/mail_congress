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

  private

  def payment_options
    {
      :ip => request.headers["REMOTE_ADDR"],
      :root_url => root_url
    }
  end

end
