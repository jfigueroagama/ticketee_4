FactoryGirl.define do
  factory :user do
    name "Example user"
    email "user@example.com"
    password "password"
    password_confirmation "password"
    
    # Admin factory is created inside the user's factory
    factory :admin_user do
      admin true
    end
  end
end