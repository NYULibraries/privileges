class PermissionValue < ActiveRecord::Base
  include Utilities::Common
  
  attr_accessible :code, :web_text, :from_aleph, :permission_code
  default_scope :order => 'web_text ASC'
  
  #Validations
  validates_presence_of :code, :web_text, :permission_code
  validate :code_is_only_prefix

  # This makes sure the code is seen as blank if it just equals the namespace prefix
  def code_is_only_prefix; errors.add(:code, "can't be blank") if (code == Settings.global.local_creation_prefix); end
  
  # Belongs to a permission
  belongs_to :permission, 
             :primary_key => "code", 
             :foreign_key => "permission_code"

  # Has many patron status permissions since they each have a permission_value_id
  has_many :patron_status_permissions,
           :inverse_of => :permission_value,
           :dependent => :destroy

  # Has many patron statuses as a result of the above relationship
  has_many :patron_statuses,
           :through => :patron_status_permissions
             
  # Reindex patron statuses and patron status permissions that are 
  # associated with this permission value when it has been changed
  after_save :reindex_associations
  after_destroy :reindex_associations
  def reindex_associations
    unless Utilities::Common::running_from_rake?
      patron_status_permissions.each {|psp| psp.delay.index!}
      patron_statuses.each {|ps| ps.delay.index!}
    end
  end
  private :reindex_associations
     
end
