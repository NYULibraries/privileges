# The application manages the relationship of users, identified as patron statuses,
# to to the permissions they have on any of the NYU libraries, identified as sublibraries.
# This application uses data automatically loaded and parsed from Aleph for permissions
# and supplements that with permissions added locally via the admin user interface.
#
# Author::    balter
# Copyright:: Copyright (c) 2013 New York University
# License::   Distributes under the same terms as Ruby
class ApplicationController < ActionController::Base
  include Searchers::PatronStatus
  include Searchers::Sublibrary
  include Searchers::PatronStatusPermission

  helper :all # include all helpers, all the time

  layout Proc.new{ |controller| (controller.request.xhr?) ? false : "application" }

  protect_from_forgery

  prepend_before_filter :check_loggedin_sso, except: [:destroy]
  def check_loggedin_sso
    if user_signed_in? && !loggedin_cookie_set?
      redirect_to logout_url(no_redirect: true)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    unless params[:no_redirect] || !ENV['SSO_LOGOUT_URL']
      ENV['SSO_LOGOUT_URL']
    else
      super(resource_or_scope)
    end
  end

  def loggedin_cookie_set?
    cookies['_login_sso'] == AESCrypt.encrypt(current_user.username, ENV['LOGOUT_SHARED_SECRET'])
  end
  private :loggedin_cookie_set?

  # Filter users to root if not admin
  def authenticate_admin
    return true if is_admin?
    redirect_to root_url and return unless is_admin? && performed?
  end
  protected :authenticate_admin

  # Return true if user is marked as admin
  def is_admin?
    @is_admin ||= (current_user.present? && current_user.admin?)
  end
  helper_method :is_admin?

  # Alias new_session_path as login_path for default devise config
  def new_session_path(scope)
    login_path
  end

  # Global function for converting string to url-friendly strings
  def urlize abnormal
    # Turns "Adjunct Faculty" to "adjunct-faculty"
    abnormal.mb_chars.normalize(:kd).strip.parameterize
  end
  helper_method :urlize
  protected :urlize

  # Reusable method for linking to the patron status based on a normalized url containing the title
  def patron_status_link id, web_text
     patron_path("#{id}-#{urlize(web_text)}")
  end
  helper_method :patron_status_link
  protected :patron_status_link

  # Prepend this string to all locallt created patron status titles
  def local_creation_prefix
    @local_creation_prefix ||= PrivilegesGuide::LOCAL_CREATION_PREFIX
  end
  helper_method :local_creation_prefix

  # Protect against SQL injection by forcing column to be an actual column name in the model
  def sort_column klass, default_column = "title_sort"
    klass.constantize.column_names.include?(params[:sort]) ? params[:sort] : default_column
  end
  protected :sort_column

  # Protect against SQL injection by forcing direction to be valid
  def sort_direction default_direction = "asc"
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default_direction
  end
  helper_method :sort_direction
  protected :sort_direction

  # Return boolean matching the url to find out if we are in the admin view
  def is_in_admin_view
    !request.path.match("/admin").nil?
  end
  alias :is_in_admin_view? :is_in_admin_view
  helper_method :is_in_admin_view?

end
