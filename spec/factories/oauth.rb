FactoryGirl.define do 
  factory :application, class: Doorkeeper::Application do
    sequence(:name) { |n| "doorkeeper_app_name_#{n}" }
    redirect_uri "http://localhost:3000/api/callback"
  end
end
