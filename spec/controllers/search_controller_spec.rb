require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:question) { create(:question, title: 'test123') }

  describe 'GET #show' do
    it 'render show view' do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    before { post :create, params: { search: 'test123', resource: 'questions' } }

    it 'assigns resource to @resource' do
      expect(assigns(:resource)).to eq 'questions'
    end

    it 'assigns search to @query' do
      expect(assigns(:query)).to eq 'test123'
    end

    it 'renders create view' do
      expect(response).to render_template(:create)
    end
  end
end
