class User < ActiveRecord::Base
  # Login with NYULibraris OAuth provider
  devise :omniauthable, omniauth_providers: [:nyulibraries]
  
  serialize :user_attributes

  acts_as_indexed fields: [:firstname, :lastname, :username, :email]

  # Create a CSV format
  comma do
    username
    firstname
    lastname
    email
  end

end
