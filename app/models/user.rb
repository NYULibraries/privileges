class User < ActiveRecord::Base
  # Login with NYULibraris OAuth provider
  devise :omniauthable, omniauth_providers: [:nyulibraries]

  acts_as_indexed fields: [:firstname, :lastname, :username, :email]

  scope :non_admin, -> { where.not(admin: true) }

  # Create a CSV format
  comma do
    username
    firstname
    lastname
    email
  end

end
