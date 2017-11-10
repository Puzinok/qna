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
    it_behaves_like "API Authenticable"

    context "get answer list" do
      it 'contains answers list' do
        do_authorize(access_token: access_token.token)
        expect(response.body).to have_json_size(2)
      end
    end

    %w(id body created_at updated_at).each do |attr|
      it "answer object contains #{attr}" do
        do_authorize(access_token: access_token.token)
        expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    def do_authorize(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_authorize(access_token: access_token.token) }

      it_behaves_like "API Commentable"
      it_behaves_like "API Attachable"

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end
    end

    def do_authorize(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
          params: { format: :json }.merge(options)
    end

    def attachable
      answer
    end
  end

  describe 'POST /create' do
    context 'authorized' do
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

    def do_authorize(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: {  format: :json,
                                                                  answer: attributes_for(:answer) }.merge(options)
    end
  end
end
