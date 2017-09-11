require 'rails_helper'

describe Api::V1::UsersController do
  include_context 'user_setup'

  describe 'POST create' do
    describe 'CLIENT registration' do
      context 'when valid credentials' do
        before do
          post :create, format: :json, access_token: @client_access_token, email: 'datu.puti@puti.com', password: 'mypassword123'
        end

        it 'returns user details' do
        end
      end
    end
  end
end