require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let!(:questions) { create_list(:question, 2) }
  let!(:question) { questions.first }
  let!(:answer) { create(:answer, question: question) }
  let!(:comments) { create_list(:comment, 2, commentable: question) }
  let(:comment) { comments.first }
  let!(:attach) { create(:attachment, attachable: question) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if no access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '112233', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'contains questions list' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if no access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '112233', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      context 'comments' do
        it 'included in questions object' do
          expect(response.body).to have_json_size(2).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        %w(attachments created_at updated_at).each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s)
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        post '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if no access_token is invalid' do
        post '/api/v1/questions', params: { access_token: '112233', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      it 'returns status 201' do
        post '/api/v1/questions', params: { format: :json,
                                            question: attributes_for(:question),
                                            access_token: access_token.token }
        expect(response.status).to eq 201
      end

      it 'create question' do
        expect {
          post '/api/v1/questions', params: { format: :json,
                                              question: attributes_for(:question),
                                              access_token: access_token.token }
        }.to change(Question, :count).by(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "returns question contains #{attr}" do
          post '/api/v1/questions', params: { format: :json,
                                              question: attributes_for(:question),
                                              access_token: access_token.token }

          expect(response.body).to be_json_eql(Question.last.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      %w(title body).each do |attr|
        it "return error if #{attr} blank " do
          post '/api/v1/questions', params: { format: :json,
                                            question: attributes_for(:invalid_question),
                                            access_token: access_token.token }

          expect(response.body).to be_json_eql("can't be blank".to_json).at_path("errors/#{attr}/0")
        end
      end
    end
  end
end
