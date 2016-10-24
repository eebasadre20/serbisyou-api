Rails.application.routes.draw do
  use_doorkeeper
  resources :users, defaults: { format: :json }
end
