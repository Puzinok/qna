require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  
  describe 'GET #new' do
    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { post :create }
    context 'with valid attributes' do
      it 'saves new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
    end
  end
end