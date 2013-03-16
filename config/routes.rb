Datachimp::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "contests#index"

  resources :contests do
    resources :entries do
      member do
        post :rate
      end
      resources :feedbacks, only: [:new, :create, :edit, :update, :destroy]
    end
  end
end
