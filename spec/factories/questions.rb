FactoryGirl.define do
  factory :question do
    factory :valid_question do
      title "MyString"
      body "MyText"
      user
    end

    factory :invalid_question do
      title nil
      body nil
      user nil
    end
  end
end
