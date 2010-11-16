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

  def url_for(options = nil)
    case options
    when Hash
      if Rails.env == 'production'
        options[:protocol] = 'https'
      end
    end
    super
  end

  helper_method :url_for 
end
