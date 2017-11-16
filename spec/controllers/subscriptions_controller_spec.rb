require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:users_question) { create(:question, user: @user) }

    context 'Authenticated user' do
      sign_in_user

      it 'create subscription for question' do
        expect { post :create, params: { question_id: question, format: :js } }
          .to change(question.subscriptions, :count).by(1)
      end

      it 'does not create if subscription exist' do
        expect { post :create, params: { question_id: users_question, format: :js } }
          .to_not change(question.subscriptions, :count)
      end
    end

    context 'Guest' do
      it 'does not create subscription' do
        expect { post :create, params: { question_id: question, format: :js } }
          .to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      sign_in_user
      let!(:subscription) { create(:subscription, user: @user) }

      it 'can delete own subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }
          .to change(Subscription, :count).by(-1)
      end
    end

    context 'Guest' do
      let!(:subscription) { create(:subscription) }

      it 'can delete own subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }
          .to_not change(Subscription, :count)
      end
    end
  end
end
