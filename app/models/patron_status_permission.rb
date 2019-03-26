# This class ties patron status/sublibrary value pairs to permission/permission value pairs
# it is the primary associative table in this application
class PatronStatusPermission < ActiveRecord::Base
  include Utilities::Common

  #Validations
  validates_presence_of :patron_status_code, :permission_value_id, :sublibrary_code

  # Belongs to a particular permission_value and maintains that id
  belongs_to :permission_value

  # Belongs to a sublibrary
  belongs_to :sublibrary,
          primary_key: "code",
          foreign_key: "sublibrary_code",
          touch: true

  # Belongs to a patron status
  belongs_to :patron_status,
          primary_key: "code",
          foreign_key: "patron_status_code",
          touch: true

  # Has one permission  through the permission value id
  has_one :permission,
          through: :permission_value

  # The Sunspot searchable index
  searchable auto_index: Utilities::Common::index? do
    string :patron_status_code, stored: true
    string :sublibrary_code, stored: true
    integer :permission_value_id, stored: true
    boolean :from_aleph, stored: true
    boolean :visible, stored: true
    boolean :permission_visible, stored: true do
      permission_value&.permission&.visible
    end
  end
end
