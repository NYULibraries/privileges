# The application manages the relationship of users, identified as patron statuses,
# to to the permissions they have on any of the NYU libraries, identified as sublibraries.
# This application uses data automatically loaded and parsed from Aleph for permissions
# and supplements that with permissions added locally via the admin user interface.
#
# Author::    balter
# Copyright:: Copyright (c) 2013 New York University
# License::   Distributes under the same terms as Ruby
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  layout Proc.new{ |controller| (controller.request.xhr?) ? false : "application" }

  protect_from_forgery
  before_action :set_raven_context

  def current_user_dev
    @current_user ||= User.find_by_username('admin')
  end
  alias_method :current_user, :current_user_dev if Rails.env.development?

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

  # This makes sure you redirect to the correct location after
  # logging in or after getting sent back not logged in
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  # After signing out from the local application,
  # redirect to the logout path for the Login app
  def after_sign_out_path_for(resource_or_scope)
    if logout_path.present?
      logout_path
    else
      super(resource_or_scope)
    end
  end

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

  private

  def logout_path
    if ENV['LOGIN_URL'].present? && ENV['SSO_LOGOUT_PATH'].present?
      "#{ENV['LOGIN_URL']}#{ENV['SSO_LOGOUT_PATH']}"
    end
  end

  def admin_view?
    is_admin? && is_in_admin_view?
  end

  def set_raven_context
    Raven.user_context(id: current_user&.id, username: current_user&.username, email: current_user&.email, ip_address: request.ip)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

end
