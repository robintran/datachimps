Datachimp::Application.routes.draw do

  resources :entries


  resources :contests


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "home#index"

  resource :contests do
    resource :entries do
      member do
        post :add_rating
      end
      resource :feedbacks, only: [:create, :update, :destroy]
    end
  end
end
