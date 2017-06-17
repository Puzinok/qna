FactoryGirl.define do
  factory :answer do
    factory :valid_answer do
      body "My Answer text"
      question
    end

    factory :invalid_answer do
      body nil
      question nil
    end
  end
end
