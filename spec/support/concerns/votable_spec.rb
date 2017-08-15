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

  describe '#vote' do
    let(:votable) { create(described_class.to_s.underscore.to_sym) }
    let(:user) { create(:user) }

    it 'User voting for question' do
      expect { votable.vote(user, 1) }.to change(votable, :rating).by(1)
    end

    it 'User voting against' do
      expect { votable.vote(user, -1) }.to change(votable, :rating).by(-1)
    end
  end

  describe '#vote_destroy' do
    let(:users) { create_list(:user, 2) }
    let(:votable) { create(described_class.to_s.underscore.to_sym) }
    let!(:vote) { create(:vote, votable: votable, user: users[0], value: 1) }

    it "User destroy own vote" do
      expect { votable.vote_destroy(users[0]) }.to change(votable.votes, :count).by(-1)
    end

    it "User can't destroy other's vote" do
      expect { votable.vote_destroy(users[1]) }.to_not change(votable.votes, :count)
    end
  end
end
