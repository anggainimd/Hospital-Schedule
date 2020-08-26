Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :hospitals, only: [:index]
      resources :doctors, only: [:index] do
        collection do 
          get "schedules" 
        end
      end
      resources :bookings, only: [:index, :create]
    end
  end
end
