require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  
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
end
