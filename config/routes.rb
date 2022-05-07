Rails.application.routes.draw do
  resources :condominios
  root 'welcome#index'
  get 'sign_in', to: "sessions#new"
  post 'sign_in', to: "sessions#create"
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
