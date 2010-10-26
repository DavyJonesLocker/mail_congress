class LettersController < ApplicationController
  def create
    letter = Letter.create(params[:letter])
  end
end
