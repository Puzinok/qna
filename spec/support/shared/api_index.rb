shared_examples "API Indexable" do
  context "get list" do
    it 'contains objects list' do
      do_authorize(access_token: access_token.token)
      expect(response.body).to have_json_size(2)
    end
  end
end