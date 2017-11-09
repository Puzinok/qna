shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if no access_token' do
      do_authorize
      expect(response.status).to eq 401
    end

    it 'returns 401 status if no access_token is invalid' do
      do_authorize(access_token: '112233')
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    it 'returns success status' do
      do_authorize(access_token: access_token.token)
      expect(response).to be_success
    end
  end
end
