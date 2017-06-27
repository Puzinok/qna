FactoryGirl.define do
  sequence :question_title do |n|
    "Question test title #{n}"
  end

  sequence :question_body do |n|
    "Question test body #{n}"
  end

  factory :question do
    factory :valid_question do
      title :question_title
      body :question_body
      user
    end

    factory :invalid_question do
      title nil
      body nil
      user nil
    end
  end
end
