FactoryGirl.define do
  sequence(:title) { |n| "Test title #{n}" }
  sequence(:body) { |n| "Test body #{n}" }

  factory :questions, class: Question do
    factory :question do
      title
      body
      user
    end

    factory :invalid_question do
      title nil
      body nil
      user nil
    end
  end
end
