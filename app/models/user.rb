class User < ApplicationRecord
  devise :trackable
  # Login with NYULibraris OAuth provider
  devise :omniauthable, omniauth_providers: [:nyulibraries]

  acts_as_indexed fields: [:firstname, :lastname, :username, :email]

  scope :non_admin, -> { where.not(admin: true) }
  scope :admin, -> { where(admin: true) }
  scope :inactive, -> { where("last_sign_in_at IS NULL OR last_sign_in_at < ?", 1.year.ago) }

  # Create a CSV format
  comma do
    username
    firstname
    lastname
    email
  end

end
