# User factory
FactoryGirl.define do
  factory :user do
    sequence :username do |n| "user#{n}" end
    email { "#{username}@example.com" }
    firstname 'Dev'
    lastname 'Eloper'
    institution_code 'NYU'
    patron_status '51'
    provider 'nyulibraries'
    last_sign_in_at Time.now

    factory :admin do
      admin true
    end
  end
end
