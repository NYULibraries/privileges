class Sublibrary < ApplicationRecord
  include Utilities::Common

  # Defines a scope of visible sublibraries where the web text is not null or blank and the visible flag is set to true
  scope :visible, ->{ where("sublibraries.web_text <> ? AND NOT(sublibraries.web_text IS NULL) and sublibraries.visible", "") }

  #Validations
  validates :code, :presence => true, :uniqueness => true
  validate :code_is_only_prefix
  validate :web_text_required_if_not_from_aleph

  # Required web_text if not from Aleph
  def web_text_required_if_not_from_aleph
    errors.add(:web_text, "can't be blank") if (!from_aleph and web_text.blank?)
  end
  
  # This makes sure the code is seen as blank if it just equals the namespace prefix
  def code_is_only_prefix
    errors.add(:code, "can't be blank") if (code == PrivilegesGuide::LOCAL_CREATION_PREFIX)
  end

  #Has many patron status permissions since they each have a sublibrary
  has_many :patron_status_permissions,
           :primary_key => "code",
           :foreign_key => "sublibrary_code",
           :dependent => :destroy

  # The Sunspot searchable object
  searchable :auto_index => Utilities::Common::index? do
    text :web_text, :original_text, :code, :under_header
    string :web_text, :stored => true do
      (web_text.blank?) ? nil : web_text
    end
    string :code, :stored => true
    boolean :visible, :stored => true
    boolean :visible_frontend, :stored => true do
      (!code.blank? && !web_text.blank? && visible)
    end
    boolean :from_aleph, :stored => true
    string :original_text
    string :under_header, :stored => true do
      (under_header.blank?) ? "Other NYU Libraries" : under_header
    end
    string :sort_header, :stored => true do
      (under_header.blank?) ? "other nyu libraries" : under_header.downcase.gsub(/^nyu/, '!nyu')  # Force nyu to be first
    end
    # Strip tags to sort
    string :sort_text, :stored => true do
      web_text.downcase.gsub(/<\/?[^>]*>/, "") unless web_text.nil?
    end
  end

end
