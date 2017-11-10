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
    it_behaves_like "API Authenticable"

    context "get question list" do
      it 'contains questions list' do
        do_authorize(access_token: access_token.token)
        expect(response.body).to have_json_size(2)
      end
    end

    %w(id title body created_at updated_at).each do |attr|
      it "question object contains #{attr}" do
        do_authorize(access_token: access_token.token)
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end

    def do_authorize(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_authorize(access_token: access_token.token) }

      it_behaves_like "API Commentable"
      it_behaves_like "API Attachable"

      context 'question' do
        %w(id title body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s)
          end
        end
      end
    end

    def do_authorize(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end

    def attachable
      question
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
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

          expect(response.body).to be_json_eql(Question.last.send(attr.to_sym).to_json).at_path(attr.to_s)
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

    def do_authorize(options = {})
      post '/api/v1/questions', params: { format: :json,
                                          question: attributes_for(:question) }.merge(options)
    end
  end
end
