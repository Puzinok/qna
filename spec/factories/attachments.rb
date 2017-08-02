FactoryGirl.define do
  factory :attachment do
    file Rack::Test::UploadedFile.new(Rails.root.join('spec', 'spec_helper.rb'))
  end
end
