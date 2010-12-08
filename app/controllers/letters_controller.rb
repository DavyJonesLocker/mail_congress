class LettersController < ApplicationController
  def show
    letter = Letter.new(params[:letter])
    render :text => letter.to_png
  end

end
