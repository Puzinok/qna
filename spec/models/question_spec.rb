require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
  it { should have_many(:votes) }

  describe '#rating' do
    let(:question) {create(:question) }
    let(:users) { create_list(:user, 3) }
    let!(:vote_plus) { create(:vote, value: 1, votable: question, user: users[0]) }
    let!(:vote_plus_2) { create(:vote, value: 1, votable: question, user: users[1]) }
    let!(:vote_minus) { create(:vote, value: -1, votable: question, user: users[2]) }

    it 'calculate votes' do
      expect(question.rating).to eq 1
    end
  end

  describe '#voted?' do
    let(:question) {create(:question) }
    let(:users) { create_list(:user, 2) }
    let!(:vote) { create(:vote, user: users[0], votable: question, value: 1 ) }

    it 'User is voted for a question' do
      expect(question).to be_voted(users[0])
    end

    it 'User is not voted for a question' do
      expect(question).not_to be_voted(users[1])
    end
  end

end
