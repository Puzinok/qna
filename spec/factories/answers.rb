FactoryGirl.define do
  factory :answers, class: Answer do
    factory :answer do
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
