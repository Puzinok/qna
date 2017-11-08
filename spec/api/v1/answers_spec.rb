require 'rails_helper'

describe 'Answer API' do
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answer1) { create(:answer, question: question) }
  let!(:attach) { create(:attachment, attachable: answer) }
  let!(:comments) { create_list(:comment, 2, commentable: answer) }
  let(:comment) { comments.first }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if no access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: '112233', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'contains answers list' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if no access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { access_token: '112233', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      context 'comments' do
        it 'included in answer object' do
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
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s)
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if no access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { access_token: '112233', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      it 'returns status 201' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                   answer: attributes_for(:answer),
                                                                   access_token: access_token.token }
        expect(response.status).to eq 201
      end

      it 'create answer' do
        expect {
          post "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                     answer: attributes_for(:answer),
                                                                     access_token: access_token.token }
        }.to change(question.answers, :count).by(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "returns answer contains #{attr}" do
          post "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                     answer: attributes_for(:answer),
                                                                     access_token: access_token.token }

          expect(response.body).to be_json_eql(Answer.last.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      it "return error if body blank " do
        post "/api/v1/questions/#{question.id}/answers", params: {  format: :json,
                                                                    answer: attributes_for(:invalid_answer),
                                                                    access_token: access_token.token }

        expect(response.body).to be_json_eql("can't be blank".to_json).at_path("errors/body/0")
      end
    end
  end
end
