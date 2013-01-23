PrivilegesGuide::Application.routes.draw do
  scope "admin" do
    resources :sublibraries
    resources :users
    resources :patron_status_permissions
    resources :permission_values
    resources :permissions
    resources :patron_statuses
    resources :application_details
    
    match "clear_patron_data", :to => "users#clear_patron_data"
  end
  
  resources :user_sessions
  match 'login', :to => 'user_sessions#new', :as => :login
  match 'logout', :to => 'user_sessions#destroy', :as => :logout
  match 'validate', :to => 'user_sessions#validate', :as => :validate
  
  match 'permissions/update_order', :controller => 'permissions', :action => 'update_order'
  match 'patron_status_permissions/update_multiple', :controller => 'patron_status_permissions', :action => 'update_multiple'
  
  match 'search' => 'access_grid#search', :as => :search
  match 'patrons/:id' => 'access_grid#show_patron_status', :as => :patron
  match 'patrons(.:format)' => "access_grid#index_patron_statuses", :as => :patrons
  
  root :to => "access_grid#index_patron_statuses"
end
