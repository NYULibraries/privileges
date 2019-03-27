class PermissionValue < ActiveRecord::Base
  include Utilities::Common

  default_scope { order('web_text ASC') }

  #Validations
  validates_presence_of :code, :web_text, :permission_code
  validate :code_is_only_prefix

  # This makes sure the code is seen as blank if it just equals the namespace prefix
  def code_is_only_prefix; errors.add(:code, "can't be blank") if (code == PrivilegesGuide::LOCAL_CREATION_PREFIX); end

  # Belongs to a permission
  belongs_to :permission,
             primary_key: "code",
             foreign_key: "permission_code"

  # Has many patron status permissions since they each have a permission_value_id
  has_many :patron_status_permissions,
           inverse_of: :permission_value,
           dependent: :destroy

  # Has many patron statuses as a result of the above relationship
  has_many :patron_statuses,
           through: :patron_status_permissions

end
