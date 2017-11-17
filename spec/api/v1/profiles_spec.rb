require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_authorize(access_token: access_token.token) }

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

    def do_authorize(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /users' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:users) { create_list(:user, 2) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_authorize(access_token: access_token.token) }

      it 'respons status 200' do
        expect(response).to be_success
      end

      it 'contains all users' do
        users.each do |user|
          expect(response.body).to include_json(user.to_json)
        end
      end

      %w(id email updated_at created_at).each do |attr|
        it "contains #{attr}" do
          users.each_with_index do |user, index|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{index}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          users.each do |index|
            expect(response.body).to_not have_json_path("#{index}/#{attr}")
          end
        end
      end

      it 'does not contains resource owner' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end

    def do_authorize(options = {})
      get '/api/v1/profiles/users', params: { format: :json }.merge(options)
    end
  end
end
