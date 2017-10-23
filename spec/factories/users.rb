FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password('12345678')
    password_confirmation('12345678')
    confirmed_at Time.now - 1.days # confirmable
  end
end
