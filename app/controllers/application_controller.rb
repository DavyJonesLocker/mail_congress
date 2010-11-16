class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  private
  
  def authenticate
    if Rails.env == 'production'
      authenticate_or_request_with_http_basic do |username, password|
        username == "alpha" && password == "1234567890"
      end
    end
  end

end
