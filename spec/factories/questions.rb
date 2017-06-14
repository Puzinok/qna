FactoryGirl.define do
  factory :question do
    factory :valid_question do
      title "MyString"
      body "MyText"
    end

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
