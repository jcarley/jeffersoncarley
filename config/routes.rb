Jeffersoncarley::Application.routes.draw do

  root :to => "home#index"

  match '/auth/:provider/callback' => "sessions#create"
  match '/logout' => "sessions#destroy", :as => :logout
  match '/auth/failure' => "sessions#failure", :as => :login_failure

end
