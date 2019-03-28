# This class defines the patron status type,
# the top level data type of this application
class PatronStatus < ApplicationRecord
  include Utilities::Common

  #Validations
  validates :code, :presence => true, :uniqueness => true
  validate :web_text_required_if_not_from_aleph
  validate :code_is_only_prefix

  # Required web_text if not from Aleph
  def web_text_required_if_not_from_aleph; errors.add(:web_text, "can't be blank") if (!from_aleph and web_text.blank?); end
  # This makes sure the code is seen as blank if it just equals the namespace prefix
  def code_is_only_prefix; errors.add(:code, "can't be blank") if (code == PrivilegesGuide::LOCAL_CREATION_PREFIX); end

  # Has many patron status permissions associated with it
  has_many :patron_status_permissions,
           :primary_key => "code",
           :foreign_key => "patron_status_code",
           :dependent => :destroy

  # Has many sublibraries where patron status permissions ties them together
  has_many :sublibraries,
           :through => :patron_status_permissions

  # Has many permissions where patron status permissions ties them together
  has_many :permissions,
           :through => :patron_status_permissions

  has_many :permission_values,
           :through => :permissions

  # The Sunspot searchable object with contidional auto_index
  searchable :auto_index => Utilities::Common::index? do
    text :keywords, :boost => 5.0
    text :web_text, :code, :description, :under_header, :original_text
    string :description, :stored => true
    string :original_text
    string :code, :stored => true
    boolean :from_aleph, :stored => true
    string :web_text, :stored => true do
      (web_text.blank?) ? nil : web_text
    end
    string :under_header, :stored => true do
      (under_header.blank?) ? "Other" : under_header
    end
    boolean :visible, :stored => true
    string :sort_header, :stored => true do
      (under_header.blank?) ? "other" : under_header.downcase.gsub(/^nyu/, '!nyu')  # Force nyu to be first
    end
    # Creates an array of references to the sublibraries this patron status has access to
    string :sublibraries_with_access, :references => Sublibrary, :stored => true, :multiple => true do
      no_access_explicit = sublibraries.visible.select("distinct sublibraries.code").where("patron_status_permissions.permission_value_id" => 45).map(&:code)
      access = Sublibrary.visible.select("distinct sublibraries.code").joins(:patron_status_permissions => {:permission_value => :permission}).where("patron_status_permissions.patron_status_code" => code, "patron_status_permissions.visible" => true, "permissions.visible" => true).map(&:code)
      access - no_access_explicit
    end
  end

end
