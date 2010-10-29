class PaymentsController < ApplicationController
  def new
    @letter  = Letter.new(params[:letter])
    @payment = @letter.build_payment
  end
end
