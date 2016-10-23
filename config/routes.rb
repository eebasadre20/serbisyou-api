Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, only: :registrations,
    controllers: { 
      registrations: 'users/registrations'
    }, defaults: { format: :json }

  resources :users, defaults: { format: :json }
end
