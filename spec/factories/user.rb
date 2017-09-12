FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "serbisyou#{n}@serbisyou.com" }
    password "tenderlove"
    password_confirmation "tenderlove"
    current_sign_in_ip "127.0.0.1"      

    factory :service_provider do
      after( :create ) { |user, evaluator| user.add_role 'service_provider' }
    end

    factory :client do
      after( :create ) { |user, evaluator| user.add_role 'client' }
    end

    factory :office_admin do 
      after( :create ) { |user, evaluator| user.add_role 'office_admin' }
    end
  end
end
