# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
username = 'admin'
if Rails.env.development? and User.find_by_username(username).nil?
  user = User.create!({
    username: username,
    firstname: 'Dev',
    lastname: 'Eloper',
    email: 'dev.eloper@library.edu',
    aleph_id: (ENV['BOR_ID'] || 'BOR_ID'),
    institution_code: :NYU,
    patron_status: '51',
    admin: true
  })
  user.save!
end
