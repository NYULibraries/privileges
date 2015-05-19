Rails.application.routes.draw do
  scope "admin" do
    resources :sublibraries
    resources :users
    resources :patron_status_permissions
    resources :permission_values
    resources :permissions
    resources :patron_statuses
    resources :application_details

    get 'clear_patron_data' => 'users#clear_patron_data'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login', to: redirect("/users/auth/nyulibraries"), as: :login
  end

  patch 'permissions/update_order' => 'permissions#update_order'
  patch 'patron_status_permissions/update_multiple' => 'patron_status_permissions#update_multiple'

  get 'search' => 'access_grid#search', as: :search
  get 'patrons/:id' => 'access_grid#show_patron_status', as: :patron
  get 'patrons(.:format)' => 'access_grid#index_patron_statuses', as: :patrons

  root to: 'access_grid#index_patron_statuses'

  # Endpoint that login can hit to remotely log user out
  delete 'sso_logout' => 'users/omniauth_logout#sso_logout', constraints: { format: :json }
end
