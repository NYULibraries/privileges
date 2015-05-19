class Users::OmniauthLogoutController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.headers['X-CSRF-Token'] == ENV['LOGIN_SHARED_SECRET'] }
  respond_to :json

  def sso_logout
    sign_out if current_user
    unless current_user
      head :ok
    else
      head :bad_request
    end
  end

end
