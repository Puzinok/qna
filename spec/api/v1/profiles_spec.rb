require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if no access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '112233', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'return status 200' do
        expect(response).to be_success
      end

      %w(id email updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr.to_s)
        end
      end
    end
  end
end
