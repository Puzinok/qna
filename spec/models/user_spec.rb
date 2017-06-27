require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  context '.author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'User is an author of resource.' do
      expect(user.author_of?(question)).to eq true
    end

    it 'User is not author of resource.' do
      another_user = create(:user)
      expect(another_user.author_of?(question)).to eq false
    end
  end
end