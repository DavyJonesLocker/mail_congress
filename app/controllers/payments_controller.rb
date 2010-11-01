class PaymentsController < ApplicationController
  def new
    @letter  = Letter.new(params[:letter])
    @payment = @letter.build_payment
  end

  def create
    @letter  = Letter.new(params[:letter])
    @payment = Payment.new(params[:payment])
    if @payment.make(@letter.recipients.size, { :email => @letter.email, :ip => request.headers["REMOTE_ADDR"] })
      @letter.save
      redirect_to thank_you_path
    end
  end
end
