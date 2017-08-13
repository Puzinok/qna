require 'rails_helper'

RSpec.shared_examples "votable" do
  describe '#rating' do
    let(:users) { create_list(:user, 3) }
    let!(:votable) { create(described_class.to_s.underscore.to_sym) }
    let!(:vote_plus) { create(:vote, value: 1, votable: votable, user: users[0]) }
    let!(:vote_plus_2) { create(:vote, value: 1, votable: votable, user: users[1]) }
    let!(:vote_minus) { create(:vote, value: -1, votable: votable, user: users[2]) }

    it 'calculate votes' do
      expect(votable.rating).to eq 1
    end
  end

  describe '#voted?' do
    let(:votable) { create(described_class.to_s.underscore.to_sym) }
    let(:users) { create_list(:user, 2) }
    let!(:vote) { create(:vote, user: users[0], votable: votable, value: 1) }

    it 'User is voted for a question' do
      expect(votable).to be_voted(users[0])
    end

    it 'User is not voted for a question' do
      expect(votable).not_to be_voted(users[1])
    end
  end
end
