require 'rails_helper'

describe Api::V1::UsersController do
  include_context 'user_setup'

  describe 'POST create' do
    describe 'CLIENT registration' do
      context 'when valid credentials' do
        before do
          post :create, format: :json, access_token: @client_access_token, email: 'datu.puti@puti.com', password: 'mypassword123', client_id: app.uid, client_secret: app.secret
        end

        it 'returns user details' do
          expect( response ).to have_http_status( 201 )

          expect( JSON( response.body )['token'] ).not_to be nil
          expect( JSON( response.body )['refresh_token'] ).not_to be nil
          expect( JSON( response.body )['expires_in'] ).not_to be nil
        end
      end

      context 'when invalid credentials' do
        context 'when user email already exist' do
          before do
            post :create, format: :json, access_token: @client_access_token, email: 'datu.puti@puti.com', password: 'mypassword123', client_id: app.uid, client_secret: app.secret
          end

          it 'returns error email has already taken' do
          end
        end
      end
    end
  end
end