class UserSession < Authlogic::Session::Base
  pds_url Settings.login.pds_url
  calling_system Settings.login.calling_system
  anonymous false
  
  def additional_attributes
    h = {}
    return h unless pds_user
    h[:access_grid_admin] = true if Settings.login.default_admins.include? pds_user.uid
    return h
  end
  
  # Hook to determine if we should attempt to establish a PDS session
  def attempt_sso?
    if controller.request.format.json?
      return false
    else
      super
    end
  end

end 