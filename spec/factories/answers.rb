FactoryGirl.define do
  sequence :answer_body do |n|
    "Test answer body #{n}"
  end

  factory :answer do
    factory :valid_answer do
      body :answer_body
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
