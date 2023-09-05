# config/routes.rb

Rails.application.routes.draw do
  resources :properties do
    member do
      delete :delete_photo, to: 'properties#delete_photo'
    end
  end
  resources :test
  resources :password_resets, only: [:create, :edit, :update], param: :id
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  get '/member-data', to: 'members#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end