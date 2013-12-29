FactoryGirl.define do
  sequence(:email) {|n| "user#{n}@example.com"}
  
  factory :user do
    name "Example user"
    email {generate(:email)}
    password "password"
    password_confirmation "password"
    
    # Admin factory is created inside the user's factory
    factory :admin_user do
      admin true
    end
  end
end