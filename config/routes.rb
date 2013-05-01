Jeffersoncarley::Application.routes.draw do

  root :to => "home#index"

  get '/posts' => 'posts#index', :as => :post_index
  get '/posts/:id' => 'posts#show', :as => :post

end
