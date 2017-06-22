require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:valid_question) }
  let(:answer) { create(:valid_answer, question: question ) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assing answer @question to question' do
      expect(assigns(:question)).to eq question
    end

    it 'assings new Answer to new @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new answer in database' do
        expect {
          post :create, params: { answer: attributes_for(:valid_answer), question_id: question }
        }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:valid_answer), question_id: question }
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save new answer in database' do
        expect {
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        }.to_not change(Answer, :count)
      end

      it 'renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author of the answer' do
      let!(:user_answer) { create(:valid_answer, question: question, user: @user) }

      it 'can delete the answer' do
        expect { delete :destroy, params: { id: user_answer } }.to change(@user.answers, :count).by(-1)
      end

      it 'redirect to question page' do
        delete :destroy, params: { id: user_answer }
        expect(response).to redirect_to user_answer.question
      end
    end

    context 'non author of the answer' do
      let(:user) { create(:user) }
      let!(:answer) { create(:valid_answer, question: question, user: user) }

      it 'cannot delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirest to question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
