FactoryGirl.define do
  factory :user do
    name "Example user"
    email "user@example.com"
    password "password"
    password_confirmation "password"
  end
end