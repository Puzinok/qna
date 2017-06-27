require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:valid_question) }
  let(:answer) { create(:valid_answer, question: question) }

  describe 'POST #create' do
    context 'Authenticate user try create answer' do
      sign_in_user

      context 'with valid attributes' do
        it 'save new answer in database' do
          expect {
            post :create, params: {
              answer: attributes_for(:valid_answer),
              question_id: question,
              user: @user
            }
          }.to change(question.answers, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: {
            answer: attributes_for(:valid_answer),
            question_id: question,
            user: @user
          }
          expect(response).to redirect_to question_path(assigns(:question))
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
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Non authenticate user try create answer' do
      it 'doesnt save new answer in database' do
        expect {
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, user: nil }
        }.to_not change(Answer, :count)
      end

      it 'redirect to sign_in page' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author of the answer' do
      let!(:user_answer) { create(:valid_answer, question: question, user: @user) }

      it 'can delete the answer' do
        expect { delete :destroy, params: { id: user_answer } }.to change(Answer, :count).by(-1)
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

      it 're-render question show page' do
        delete :destroy, params: { id: answer }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
