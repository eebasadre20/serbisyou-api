RSpec.shared_context 'api_setup' do
  let( :user ) { create( :user ) }
  let( :app ) { Doorkeeper::Application.create!( name: 'Test API', redirect_uri: 'https://localhost:3000/api/callback' ) }
end
