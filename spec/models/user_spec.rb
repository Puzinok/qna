require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:oauth_providers) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'User already has authorization' do
      it 'return the user' do
        user.oauth_providers.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'User has not authorization' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      context 'User already exist' do
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'create oauth_provider for user' do
          expect { User.find_for_oauth(auth) }.to change(user.oauth_providers, :count).by(1)
        end

        it 'creates oauth_provider with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.oauth_providers.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'User does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'user@exmpl.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'create oauth_provider for user' do
          user = User.find_for_oauth(auth)
          expect(user.oauth_providers).to_not be_empty
        end

        it 'creates oauth_provider with provider and uid' do
          authorization = User.find_for_oauth(auth).oauth_providers.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'User does not exist, email is not present' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: nil }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills email with temporary email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq "temp_email_#{auth.uid}@#{auth.provider}.com"
        end

        it 'create oauth_provider for user' do
          expect { User.find_for_oauth(auth) }.to change(OauthProvider, :count).by(1)
        end

        it 'creates oauth_provider with provider and uid' do
          authorization = User.find_for_oauth(auth).oauth_providers.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe "#email_verified?" do
    let(:user) { create(:user) }
    let(:user_temp_email) { create(:user, email: 'temp_email_123456@twitter.com') }

    it 'User with valid email' do
      expect(user).to be_email_verified
    end

    it 'User with temporary email' do
      expect(user_temp_email).to_not be_email_verified
    end
  end

  describe "#find_subscribe" do
    let(:user) { create :user }
    let(:question) { create(:question) }
    let!(:subscriptions) { create(:subscription, question: question, user: user) }

    it 'find users subscription for question' do
      expect(user.find_subscribe(question)).to be_a(Subscription)
    end
  end
end
