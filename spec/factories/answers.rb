FactoryGirl.define do
  factory :answer do
    factory :valid_answer do
      body
      question
      user
    end

    factory :invalid_answer do
      body nil
      question nil
      user nil
    end
  end
end
