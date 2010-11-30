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

    valid = @letter.valid?
    valid = @payment.valid? && valid

    if valid && @payment.make(@letter.recipients.size, { :email => @letter.sender.email, :ip => request.headers["REMOTE_ADDR"] })
      @letter.generate_follow_up_id!
      @letter.save
      PrintJob.enqueue(@letter)
      redirect_to thank_you_path
    else
      render 'new'
    end
  end
end
