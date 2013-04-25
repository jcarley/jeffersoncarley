Jeffersoncarley::Application.routes.draw do

  root :to => "home#index"

  get '/posts' => 'posts#index', :as => :post_index
  get '/posts/:id' => 'posts#show', :as => :post

  match '/auth/:provider/callback' => "sessions#create"
  match '/logout' => "sessions#destroy", :as => :logout
  match '/auth/failure' => "sessions#failure", :as => :login_failure

end
