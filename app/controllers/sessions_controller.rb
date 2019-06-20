class SessionsController < Devise::SessionsController
  def destroy
    if request.post?
      super
    else
      redirect_to root_path
    end
  end
end