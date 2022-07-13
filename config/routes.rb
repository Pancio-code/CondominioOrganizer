Rails.application.routes.draw do
  resources :gdrive_user_items
  resources :gdrive_condo_items
  resources :events
  get 'admin/index'
  get "condominos/choose_new_leader", to: 'condominos#choose_new_leader'
  get "condominos/get_comunicazione_del_leader", to: 'condominos#get_comunicazione_del_leader'
  get "condominios/create_comunication_for_admin", to: 'condominios#create_comunication_for_admin'
  get "admin/create_comunication_for_leader", to: 'admin#create_comunication_for_leader'
  post "admin/comunication_for_leader", to: 'admin#comunication_for_leader'
  post "condominios/comunication_for_admin", to: 'condominios#comunication_for_admin'
  post "condominos/post_comunicazione_del_leader", to: 'condominos#post_comunicazione_del_leader'
  post 'condominos/eleva_condomino', to: 'condominos#eleva_condomino'
  post 'condominos/cedi_ruolo_leader', to: 'condominos#cedi_ruolo_leader'
  post 'admin/eleva_ad_admin', to: 'admin#eleva_ad_admin'
  delete "/admin/:id" => "admin#destroy", as: :user
  resources :requests
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  authenticate(:users) do
  	resources :users
  end
  resources :enter
  resources :posts do
    resources :comments
  end
  resources :condominos,path: "condominos/new/:id" 
  resources :condominios do
    resources :posts
    resources :condominos
  end
  resources :contacts, only: [:new, :create]
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
