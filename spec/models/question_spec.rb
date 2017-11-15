require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it_behaves_like "votable"

  describe ".of_past_day" do
    let!(:questions) { create_list(:question, 2) }
    let!(:question) { create(:question, created_at: 2.day.ago)}
    
    it 'questions in the last 24 hours' do
      expect(Question.of_past_day.count).to eq 2
    end

    it 'not include older questions' do
      expect(Question.of_past_day).to_not include(question)
    end
  end
end
