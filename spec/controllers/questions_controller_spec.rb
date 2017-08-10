require 'rails_helper'

RSpec.describe  QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 3, user: user) }
    before { get :index }

    it 'user can browse list of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'build new Attachment for @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'Authenticated user create question' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves new question in database' do
          expect {
            post :create, params: { question: attributes_for(:question) }
          }.to change(Question, :count).by(1)

          expect(assigns(:question).user).to eq @user
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question) }
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

    context 'Non authenticate user try to create question' do
      it 'not save question in database' do
        expect {
          post :create, params: { question: attributes_for(:question) }
        }.to_not change(Question, :count)
      end

      it 'redirect to sign_in page' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'build new Attachment for new @answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    context 'Autheticated user' do
      sign_in_user

      context 'question author' do
        let!(:user_question) { create(:question, user: @user) }

        it 'can delete the question' do
          expect { delete :destroy, params: { id: user_question } }.to change(Question, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, params: { id: user_question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'another authenticated user' do
        let!(:question) { create(:question) }
        it 'cannot delete the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirect to questions index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
    end

    context 'Non authenticate user try to delete question' do
      let!(:question) { create(:question) }

      it 'doestn delete question from database' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context "Non authenticate try edit question" do
      let(:question) { create(:question) }

      it "doesn't update question in database" do
        patch :update, params: { id: question, question: { body: 'edited body', title: 'edited title' } }
        question.reload
        expect(question).to_not have_attributes(body: 'edited body', title: 'edited title')
      end

      it 'redirect to sign in page' do
        patch :update, params: { id: question, question: { body: 'edited body', title: 'edited title' } }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "Non author can't edit question" do
      sign_in_user
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }

      it "doesn't update question in database" do
        patch :update, params: { id: question, question: { title: 'edited title', body: 'edited body' } }, format: :js
        question.reload
        expect(question).to_not have_attributes(title: 'edited title', body: 'edited body')
      end
    end

    context "Author can edit question" do
      sign_in_user
      let(:question) { create(:question, user: @user) }

      it 'assings the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'assings question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      context 'with valid attributes' do
        it 'change question attributes' do
          patch :update, params: { id: question, question: { title: 'edited title', body: 'edited body' } }, format: :js
          question.reload
          expect(question).to have_attributes(title: 'edited title', body: 'edited body')
        end

        it 'rerender update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it "doesn't update question in datebase" do
          patch :update, params: { id: question, question: { title: '', body: '' } }, format: :js
          question.reload
          expect(question).to_not have_attributes(title: '', body: '')
        end

        it 'rerender update view' do
          patch :update, params: { id: question, question: attributes_for(:invalid_question) }, format: :js
          expect(response).to render_template :update
        end
      end
    end
  end

  describe 'POST #vote_for' do
    let(:question) { create(:question) }

    context 'Non authenticate user' do
      it 'can not change vote' do
        expect{ post :vote_for, params: { id: question } }.to_not change(Vote, :count)
      end

      it 'redirect to sign_in page' do
        post :vote_for, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Author of question' do
      sign_in_user
      let(:author_question) { create(:question, user: @user) }

      it 'can not change vote' do
        expect{ post :vote_for, params: { id: author_question } }
        .to_not change(author_question.votes, :count)
      end
    end

    context 'Authenticate user' do
      sign_in_user

      context 'can vote for question' do
        it 'should increment vote in db' do
          expect{ post :vote_for, params: { id: question } }.to change(question, :rating).by(1)
        end

        it 'response rating in json' do
          post :vote_for, params: { id: question }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["rating"]).to eq 1
        end
      end

      context 'can vote once' do
        let!(:vote) { create(:vote, votable: question, user: @user, value: 1) }

        it 'doesnt change vote in db ' do
          expect{ post :vote_for, params: { id: question }}.to_not change(question, :rating)

          expect(response).to have_http_status(422)

          expect(JSON.parse(response.body)[0]).to eq 'User can vote once!'
        end
      end
    end

  describe 'POST #vote_against' do
    let!(:question) { create(:question) }

    context 'Non authenticate user' do
      it 'can not change vote' do
        expect{ post :vote_against, params: { id: question } }.to_not change(Vote, :count)
      end

      it 'redirect to sign_in page' do
        post :vote_for, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticate user' do
      sign_in_user

      context 'can vote against question' do
        it 'should decrement vote in db' do
          expect{ post :vote_against, params: { id: question } }
          .to change(question, :rating).by(-1)
        end

        it 'response rating in json' do
          post :vote_against, params: { id: question }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["rating"]).to eq -1
        end
      end


      context 'can vote once' do
        let!(:vote) { create(:vote, votable: question, user: @user, value: -1) }

        it 'doesnt change vote in db ' do
          expect{ post :vote_against, params: { id: question } }.to_not change(question, :rating)

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)[0]).to eq "User can vote once!"
        end
      end
    end

      context 'Author of question' do
        sign_in_user
        let(:author_question) { create(:question, user: @user) }

        it 'can not change vote' do
          expect{ post :vote_against, params: { id: author_question } }
          .to_not change(author_question.votes, :count)
        end
      end
    end
  end

  describe 'DELETE #vote_reset' do
    let(:question){ create(:question) }

    context 'Authenticate user' do
      sign_in_user
      let!(:vote) { create(:vote, votable: question, user: @user, value: 1) }

      it 'destroy vote from db' do
        expect{ delete :vote_reset, params: { id: question } }
        .to change(question.votes, :count).by(-1)
      end

      it 'response rating in json' do
        delete :vote_reset, params: { id: question }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["rating"]).to eq 0
      end
    end

    context 'Non authenticate user' do
      let(:user) { create(:user) }
      let!(:vote) { create(:vote, votable: question, user: user, value: 1) }

      it 'can not change vote' do
        expect{ delete :vote_against, params: { id: question } }.to_not change(Vote, :count)
      end

      it 'redirect to sign_in page' do
        delete :vote_reset, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Author' do
      it 'doesnt reset vote' do
        expect{ delete :vote_reset, params: { id: question} }.to_not change(question.votes, :count)
      end
    end
  end
end
