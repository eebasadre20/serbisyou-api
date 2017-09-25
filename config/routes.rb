Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, defaults: { format: :json }
  # resources :users, defaults: { format: :json }

  namespace :api, constraints: lambda { |req| req.format == :json }, defaults: { format: :json } do
    use_doorkeeper do
      controllers tokens: 'oauth/tokens'
    end

    scope module: 'v1' do
      resources :users, only: [:create, :show, :update], defaults: { format: :json }
      post 'user/upload/avatar', to: 'users#upload_avatar', defaults: { format: :json }
    end   
  end
end

