class PaymentsController < ApplicationController
  def new
    @letter = Letter.new(params[:letter])
    @geoloc = GeoKit::GeoLoc.new(params[:geoloc])
    @geoloc.success = true
    if @letter.valid?
      @payment = @letter.build_payment
    else
      @letter.recipients = Legislator.search(@geoloc).map { |legislator| Recipient.new(:legislator => legislator) }
      render :template => 'search/show'
    end
  end

  def create
    @letter  = Letter.new(params[:letter])
    @payment = Payment.new(params[:payment])
    if @payment.make(@letter.recipients.size, { :email => @letter.email, :ip => request.headers["REMOTE_ADDR"] })
      @letter.save
      PrintJob.enqueue(@letter)
      redirect_to thank_you_path
    end
  end
end
