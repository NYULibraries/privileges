# User factory
FactoryGirl.define do
  factory :user do
    sequence :username do |n| "user#{n}" end
    email { "#{username}@example.com" }
    firstname 'Dev'
    lastname 'Eloper'
    institution_code 'NYU'
    patron_status '51'
  end
end
