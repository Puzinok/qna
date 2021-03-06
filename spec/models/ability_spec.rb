require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create :user }
    let(:question) { create :question, user: user }
    let(:another_question) { create :question, user: another_user }
    let(:attachment) { create(:attachment, attachable: create(:question, user: user)) }
    let(:another_attachment) { create(:attachment, attachable: create(:question, user: another_user)) }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :modify, create(:question, user: user) }
    it { should_not be_able_to :modify, create(:question, user: another_user) }

    it { should_not be_able_to :voting, create(:question, user: user) }
    it { should be_able_to :voting, create(:question, user: another_user) }

    it { should be_able_to :modify, create(:answer, user: user) }
    it { should_not be_able_to :modify, create(:answer, user: another_user) }

    it { should_not be_able_to :voting, create(:answer, user: user) }
    it { should be_able_to :voting, create(:answer, user: another_user) }

    it { should be_able_to :choose_best, create(:answer, question: question) }
    it { should_not be_able_to :choose_best, create(:answer, question: another_question) }

    it { should be_able_to :destroy, attachment }
    it { should_not be_able_to :destroy, another_attachment }

    it { should be_able_to :me, User }
    it { should be_able_to :users, User }

    it { should be_able_to :destroy, create(:subscription, user: user) }
    it { should_not be_able_to :destroy, create(:subscription, user: another_user) }
  end
end
