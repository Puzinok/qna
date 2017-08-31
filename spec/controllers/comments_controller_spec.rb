require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'Authenticate user' do
      sign_in_user

      it 'create comment' do
        expect {
          post :create, params: {
            comment: attributes_for(:comment),
            question_id: question
          }, format: :json
        }.to change(question.comments, :count).by(1)
      end
    end

    context 'Non authenticate user' do
      it "can't create comment" do
        expect {
          post :create, params: {
            comment: attributes_for(:comment),
            question_id: question
          }, format: :json
        }.to_not change(Comment, :count)
      end
    end
  end
end
