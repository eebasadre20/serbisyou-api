RSpec.shared_context 'user_setup' do
  let( :app )               { create( :application ) }
  let( :service_provider )  { create( :service_provider ) }
  let( :office_admin )      { create( :office_admin ) }
  let( :client )            { create( :client ) }
  
  before( :each ) do
    oauth_client = OAuth2::Client.new( app.uid, app.secret, { token_url: '/api/oauth/token', :raise_errors => false } ) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end

    binding.pry

    client_credentials    = oauth_client.password.get_token(client.email, client.password)
    # service_provider      = oauth_client.password.get_token(service_provider.email, service_provider.password)
    # office_admin          = oauth_client.password.get_token(office_admin.email, office_admin.password)

    # @client_access_token            = client_credentials['data']['auth']['access_token']
    # @service_provider_access_token  = service_provider['data']['auth']['access_token']
    # @office_admin                   = office_admin['data']['auth']['access_token']
  end
end