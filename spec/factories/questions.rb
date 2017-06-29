FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question title #{n}" }
    sequence(:body) { |n| "Question body #{n}" }
    user

    factory :invalid_question do
      title nil
      body nil
      user nil
    end
  end
end
