class Permission < ActiveRecord::Base
  include Utilities::Common

  #Validations
  validates :code, :presence => true, :uniqueness => true
  validate :web_text_required_if_not_from_aleph
  validate :code_is_only_prefix
  validate :increment_sort_order

  # Required web_text if not from Aleph
  def web_text_required_if_not_from_aleph; errors.add(:web_text, "can't be blank") if (!from_aleph and web_text.blank?); end
  # This makes sure the code is seen as blank if it just equals the namespace prefix
  def code_is_only_prefix; errors.add(:code, "can't be blank") if (code == PrivilegesGuide::LOCAL_CREATION_PREFIX); end
  # Incremement sort order by one
  def increment_sort_order; self.sort_order ||= Permission.maximum("sort_order").to_i + 1; end

  # Has many possible permissions values
  has_many :permission_values,
           :primary_key => "code",
           :foreign_key => "permission_code",
           :dependent => :destroy

  # Has many patron status permissions linked by the permission values they contain
  has_many :patron_status_permissions,
           :through => :permission_values

  # Has many patron statuses linked by the patron sttatus permissions it contains
  has_many :patron_statuses,
           :through => :patron_status_permissions

  # Named scopes
  scope :by_sort_order, ->{ order 'sort_order ASC, web_text ASC' }
  scope :visible, ->{ where visible: 1 }

  # Reindex patron statuses and patron status permissions that are
  # associated with this permission when it has been changed
  after_save :reindex_associations
  after_destroy :reindex_associations
  def reindex_associations
    unless Utilities::Common::running_from_rake?
      patron_statuses.delay.each {|ps| ps.delay.index!}
      patron_status_permissions.delay.each {|psp| psp.delay.index!}
    end
  end
  private :reindex_associations

end
