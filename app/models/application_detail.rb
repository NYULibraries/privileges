# This defines the class used to display text to frontend users in the application
class ApplicationDetail < ApplicationRecord
  validates_presence_of :description, :the_text
  validates :purpose, :uniqueness => true, :presence => true
  # Sort by description for backend display
  default_scope { order('description ASC') }
end
