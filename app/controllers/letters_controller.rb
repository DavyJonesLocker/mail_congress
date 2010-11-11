class LettersController < ApplicationController
  def show
    letter = Letter.new(params[:letter])
    render :text => letter.to_png
  end

  def create
    letter = Letter.create(params[:letter])
  end
end
