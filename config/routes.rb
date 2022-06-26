Rails.application.routes.draw do
  resources :requests
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  authenticate(:users) do
  	resources :users
  end
  resources :enter
  resources :condominios
  resources :contacts, only: [:new, :create]
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
