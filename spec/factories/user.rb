FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "serbisyou#{n}@serbisyou.com" }
    password "tenderlove"
    password_confirmation "tenderlove"
    current_sign_in_ip "127.0.0.1" 
  end
end
