class UserSession < Authlogic::Session::Base
  pds_url (ENV['PDS_URL'] || 'https://pds.library.nyu.edu')
  calling_system 'primo'
  anonymous false

  def additional_attributes
    h = {}
    return h unless pds_user
    h[:access_grid_admin] = true if default_admins.include? pds_user.uid
    return h
  end

  # Hook to determine if we should attempt to establish a PDS session
  def attempt_sso?
    (controller.request.format.json?) ? false : super
  end

  private
  def default_admins
    (Figs.env['PRIVILEGES_DEFAULT_ADMINS'] || ['real_user'])
  end

end
