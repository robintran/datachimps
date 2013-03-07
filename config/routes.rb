Datachimp::Application.routes.draw do

  resources :contests


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "home#index"

  resource :contests do
    resource :entries do
      resource :feedbacks, only: [:create, :update, :destroy]
    end
  end
end
