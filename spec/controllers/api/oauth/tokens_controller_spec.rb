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
        fcontext 'when valid client and user credentials' do
          before do
            request.headers['HTTP_GRANT_TYPE'] = 'password'
            request.headers['HTTP_CLIENT_ID'] = app.uid
            request.headers['HTTP_CLIENT_SECRET'] = app.secret

            post :create, params: { username: user.email, password: user.password }
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

            post :create, params: { username: 'incorrect email', password: 'incorrect password' }
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

      describe 'assertion' do
        context 'when valid client and user credentials' do
          before do
            request.headers['HTTP_GRANT_TYPE'] = 'assertion'
            request.headers['HTTP_CLIENT_ID'] = app.uid
            request.headers['HTTP_CLIENT_SECRET'] = app.secret
          end

          it 'successfully responds authentication details for login via facebook' do
            post :create, params: { email: user.email, password: "", provider: 'facebook', id: '12345678' }

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

          it 'successfully responds authentication details for login via google oauth' do
            post :create, params: { email: user.email, password: "", provider: 'google_oauth2', id: '12345678' }

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
      end
    end
  end
end
