require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'User is an author of resource.' do
      expect(user).to be_author_of(question)
    end

    it 'User is not author of resource.' do
      expect(another_user).not_to be_author_of(question)
    end
  end
end
