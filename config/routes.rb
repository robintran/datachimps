Datachimp::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "home#index"

  resources :contests do
    resources :entries do
      member do
        post :add_rating
      end
      resources :feedbacks, only: [:create, :update, :destroy]
    end
  end
end
