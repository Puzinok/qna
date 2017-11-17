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
  it { should have_many(:subscriptions).dependent(:destroy) }

  it_behaves_like "votable"

  describe ".of_past_day" do
    let!(:questions) { create_list(:question, 2, created_at: 1.day.ago) }
    let!(:question) { create(:question, created_at: 2.days.ago) }

    it "yesterday's questions" do
      expect(Question.of_past_day.count).to eq 2
    end

    it 'not include older questions' do
      expect(Question.of_past_day).to_not include(question)
    end
  end

  describe '#subscribe_author' do
    let(:author) { create(:user) }
    let(:question) { build(:question, user: author) }

    it 'create subsription for questions author' do
      expect { question.save! }.to change(author.subscriptions, :count).by(1)
    end

    it 'should subcribe author after create' do
      expect(question).to receive(:subscribe_author).and_call_original
      question.save!
    end
  end
end
