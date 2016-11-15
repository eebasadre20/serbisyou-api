Rails.application.routes.draw do
  use_doorkeeper
  resources :users, defaults: { format: :json }

  namespace :api, constraints: -> { |req| req.format == :json }, defaults: { format: :json } do
    use_doorkeeper do
      controllers tokens: 'oauth/tokens'
    end

    scope module: 'v1' do
      resources :users, only: [:create, :show, :update]
    end   
  end
end
