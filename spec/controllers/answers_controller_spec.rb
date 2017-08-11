require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'Authenticate user try create answer' do
      sign_in_user

      context 'with valid attributes' do
        it 'save new answer in database' do
          expect {
            post :create, params: {
              answer: attributes_for(:answer),
              question_id: question,
              format: :js
            }
          }.to change(question.answers, :count).by(1)

          expect(assigns(:answer).user).to eq @user
        end

        it 'renders new view' do
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question,
            format: :js
          }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'doesnt save new answer in database' do
          expect {
            post :create, params: {
              answer: attributes_for(:invalid_answer),
              question_id: question,
              format: :js
            }
          }.to_not change(Answer, :count)
        end

        it 'renders new view' do
          post :create, params: {
            answer: attributes_for(:invalid_answer),
            question_id: question,
            format: :js
          }
          expect(response).to render_template :create
        end
      end
    end

    context 'Non authenticate user try create answer' do
      it 'doesnt save new answer in database' do
        expect {
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        }.to_not change(Answer, :count)
      end

      it 'redirect to sign_in page' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user try create question' do
      sign_in_user

      context 'author the answer' do
        let!(:user_answer) { create(:answer, question: question, user: @user) }

        it 'can delete the answer' do
          expect { delete :destroy, params: { id: user_answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'rerender to question page' do
          delete :destroy, params: { id: user_answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'non author of the answer' do
        let!(:answer) { create(:answer) }

        it 'cannot delete the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
        end
      end
    end

    context 'Non authenticated user try delete answer' do
      let!(:answer) { create(:answer) }

      it 'doesnt delete answer from database' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context "Non authenticate try edit answer" do
      let!(:answer) { create(:answer, question: question) }

      it "doesn't update answer in database" do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'edited body' } }
        answer.reload
        expect(answer.body).to_not eq 'edited body'
      end

      it 'redirect to sign in page' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'edited body' } }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "Non author can't edit answer" do
      sign_in_user
      let(:user) { create(:user) }
      let(:answer) { create(:answer, question: question, user: user) }

      it "doesn't update answer in database" do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'edited body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'edited body'
      end
    end

    context "Author can edit answer" do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }

      it 'assings the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assings antwer to question' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:question)).to eq question
      end

      context 'with valid attributes' do
        it 'change answer attributes' do
          patch :update, params: { id: answer, question_id: question, answer: { body: 'edited body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'edited body'
        end

        it 'rerender update view' do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it "doesn't update answer in datebase" do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 'rerender update view' do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
          expect(response).to render_template :update
        end
      end
    end
  end

  describe "PATCH #choose_best" do
    context 'Author of question can choose the best answer' do
      context 'Author' do
        sign_in_user
        let(:author_question) { create(:question, user: @user) }
        let(:answer) { create(:answer, question: author_question) }

        it "try change 'best' attribute to true" do
          patch :choose_best, params: { answer_id: answer.id }, format: :js
          answer.reload
          expect(answer.best).to eq true
        end

        it 'render update view' do
          patch :choose_best, params: { answer_id: answer.id }, format: :js
          expect(response).to render_template :choose_best
        end
      end

      context 'Authenticate user' do
        sign_in_user
        let(:author) { create(:user) }
        let(:author_question) { create(:question, user: author) }
        let(:answer) { create(:answer, question: author_question) }

        it "try change 'best' attribute to true" do
          patch :choose_best, params: { answer_id: answer.id }, format: :js
          answer.reload
          expect(answer.best).to eq false
        end
      end

      context 'Non aunthenticate user' do
        let(:author) { create(:user) }
        let(:author_question) { create(:question, user: author) }
        let(:answer) { create(:answer, question: author_question) }

        it "try change 'best' attribute to true" do
          patch :choose_best, params: { answer_id: answer.id }, format: :js
          answer.reload
          expect(answer.best).to eq false
        end

        it "redirect to sign page" do
          patch :choose_best, params: { answer_id: answer.id }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'POST #vote_for' do
    let(:answer) { create(:answer) }

    context 'Non authenticate user' do
      it 'can not change vote' do
        expect{ post :vote_for, params: { id: answer } }.to_not change(Vote, :count)
      end

      it 'redirect to sign_in page' do
        post :vote_for, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Author of answer' do
      sign_in_user
      let(:author_answer) { create(:answer, user: @user) }

      it 'can not change vote' do
        expect{ post :vote_for, params: { id: author_answer } }
        .to_not change(author_answer.votes, :count)
      end
    end

    context 'Authenticate user' do
      sign_in_user

      context 'can vote for answer' do
        it 'should increment vote in db' do
          expect{ post :vote_for, params: { id: answer } }.to change(answer, :rating).by(1)
        end

        it 'response rating in json' do
          post :vote_for, params: { id: answer }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["rating"]).to eq 1
        end
      end

      context 'can vote once' do
        let!(:vote) { create(:vote, votable: answer, user: @user, value: 1) }

        it 'doesnt change vote in db ' do
          expect{ post :vote_for, params: { id: answer } }.to_not change(answer, :rating)
        end

        it 'resonse error json' do
          post :vote_for, params: { id: answer }, format: :js

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)['message'].first).to eq('User can vote once!')
        end
      end
    end
  end

  describe 'POST #vote_against' do
    let!(:answer) { create(:answer) }

    context 'Non authenticate user' do
      it 'can not change vote' do
        expect{ post :vote_against, params: { id: answer } }.to_not change(Vote, :count)
      end

      it 'redirect to sign_in page' do
        post :vote_for, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticate user' do
      sign_in_user

      context 'can vote against answer' do
        it 'should decrement vote in db' do
          expect{ post :vote_against, params: { id: answer } }
          .to change(answer, :rating).by(-1)
        end

        it 'response rating in json' do
          post :vote_against, params: { id: answer }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["rating"]).to eq -1
        end
      end



      context 'can vote once' do
        let!(:vote) { create(:vote, votable: answer, user: @user, value: -1) }

        it 'doesnt change vote in db ' do
          expect{ post :vote_against, params: { id: answer } }.to_not change(answer, :rating)
        end

        it 'response error json' do
          post :vote_against, params: { id: answer }

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)['message'].first).to eq "User can vote once!"
        end
      end

      context 'Author of answer' do
        sign_in_user
        let(:author_answer) { create(:answer, user: @user) }

        it 'can not change vote' do
          expect{ post :vote_against, params: { id: author_answer } }
          .to_not change(author_answer.votes, :count)
        end
      end
    end
  end

  describe 'DELETE #vote_reset' do
    let(:answer){ create(:answer) }

    context 'Authenticate user' do
      sign_in_user
      let!(:vote) { create(:vote, votable: answer, user: @user, value: 1) }

      it 'destroy vote from db' do
        expect{ delete :vote_reset, params: { id: answer } }
        .to change(answer.votes, :count).by(-1)
      end

      it 'response rating in json' do
        delete :vote_reset, params: { id: answer }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["rating"]).to eq 0
      end
    end

    context 'Non authenticate user' do
      let(:user) { create(:user) }
      let!(:vote) { create(:vote, votable: answer, user: user, value: 1) }

      it 'can not change vote' do
        expect{ delete :vote_against, params: { id: answer } }.to_not change(Vote, :count)
      end

      it 'redirect to sign_in page' do
        delete :vote_reset, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Author' do
      it 'doesnt reset vote' do
        expect{ delete :vote_reset, params: { id: answer } }.to_not change(answer.votes, :count)
      end
    end
  end
end
