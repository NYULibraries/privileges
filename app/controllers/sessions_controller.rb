class SessionsController < ApplicationController
  def login
    if request.post?
      redirect_to user_nyulibraries_omniauth_authorize_path
    end
  end
end