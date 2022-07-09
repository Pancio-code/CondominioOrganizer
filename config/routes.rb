Rails.application.routes.draw do
  get 'admin/index'
  get "condominos/choose_new_leader", to: 'condominos#choose_new_leader'
  get "condominios/create_comunication_for_admin", to: 'condominios#create_comunication_for_admin'
  post "condominios/comunication_for_admin", to: 'condominios#comunication_for_admin'
  post 'condominos/eleva_condomino', to: 'condominos#eleva_condomino'
  post 'condominos/cedi_ruolo_leader', to: 'condominos#cedi_ruolo_leader'
  post 'admin/eleva_ad_admin', to: 'admin#eleva_ad_admin'
  delete "/admin/:id" => "admin#destroy", as: :user
  resources :comments
  resources :requests
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  authenticate(:users) do
  	resources :users
  end
  resources :enter
  resources :post
  resources :condominos
  resources :condominios do
    resources :posts
    resources :condominos
  end
  resources :contacts, only: [:new, :create]
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
