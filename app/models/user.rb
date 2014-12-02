class User < ActiveRecord::Base

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
