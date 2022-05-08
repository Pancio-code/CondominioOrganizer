Rails.application.routes.draw do
  resources :condominios
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
