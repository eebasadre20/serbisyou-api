require 'rails_helper'

describe Api::Oauth::TokensController do
  include_context 'api_setup' 

  describe 'POST create' do
    describe 'grant type' do
      describe 'client credentials' do
        context 'when valid client credentials' do
          before do
            request.headers['HTTP_GRANT_TYPE'] = 'client_credentials'
            request.headers['HTTP_CLIENT_ID'] = app.uid
            request.headers['HTTP_CLIENT_SECRET'] = app.secret
            
            post :create
          end

          it 'successfully responds authentication details' do
            expect( response ).to have_http_status( 200 )
            expect( json ).to include_json( 
              success: true,
              data: {
                auth: {
                  expires_in: 86400,
                  scope: 'public',
                  token_type: 'bearer'
                }
              }
            )
            expect( json['data']['auth']['access_token'] ).to_not be_nil
          end
        end

        context 'when invalid client credentials' do
          before do
            request.headers['HTTP_GRANT_TYPE'] = 'client_credentials'
            request.headers['HTTP_CLIENT_ID'] = 'invalid uid'
            request.headers['HTTP_CLIENT_SECRET'] = 'invalid secret'

            post :create
          end

          it 'responds authentication failed' do
            expect( response ).to have_http_status( 401 )
            expect( json ).to include_json(
              success: false,
              errors: [ {
                error: 'invalid_client',
                error_description: 'Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method.'
              } ]
             )
          end
        end
      end

      describe 'password' do
        context 'when valid client and user credentials' do
          before do
            request.headers['HTTP_GRANT_TYPE'] = 'password'
            request.headers['HTTP_CLIENT_ID'] = app.uid
            request.headers['HTTP_CLIENT_SECRET'] = app.secret

            post :create, email: user.email, password: user.password
          end

          it 'successfully responds authentication details' do
            expect( response ).to have_http_status( 200 )
            expect( json ).to include_json(
              success: true,
              data: {
                auth: {
                  expires_in: 86400,
                  scope: "public",
                  token_type: "bearer"
                }
              }
             )
            expect( json['data']['auth']['access_token'] ).to_not be_nil
            expect( json['data']['auth']['access_token'] ).to_not be_nil
          end
        end

        context 'when invalid client and user credentials' do
          before do
            request.headers['HTTP_GRANT_TYPE'] = 'password'
            request.headers['HTTP_CLIENT_ID'] = 'invalid app uid'
            request.headers['HTTP_CLIENT_SECRET'] = 'invalid app secret'

            post :create, email: 'incorrect email', password: 'incorrect password'
          end

          it 'responds authentication failed' do
            expect( response ).to have_http_status( 401 )
            expect( json ).to include_json(
              success: false,
              errors: [ {
                error: 'invalid_client',
                error_description: 'Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method.'
              } ]
             )
          end
        end
      end
    end
  end
end
