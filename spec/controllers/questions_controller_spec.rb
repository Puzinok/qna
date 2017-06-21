require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #new' do
    login_user
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    login_user
    let!(:question) { create(:valid_question, user: @user) }

    context 'with valid attributes' do
      it 'saves new question in database' do
        expect {
          post :create, params: { question: attributes_for(:valid_question) }
        }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:valid_question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not save invalid question in database' do
        expect {
          post :create, params: { question: attributes_for(:invalid_question) }
        }.to_not change(Question, :count)
      end

      it 'renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:valid_question) }
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    context 'author of question' do
      login_user
      let!(:user_question) { create(:valid_question, user: @user) }

      it 'can delete the question' do
        expect { delete :destroy, params: { id: user_question } }.to change(@user.questions, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: user_question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'another authorized user' do
      login_user
      let(:question) { create(:valid_question, user: @user) }

      it 'cannot delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
