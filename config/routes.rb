Datachimp::Application.routes.draw do
  resources :credit_cards, only: [:index, :new, :create, :destroy]
  resources :bank_accounts, only: [:index, :new, :create, :destroy]
  resources :contest_followings, only: [:index, :create, :destroy]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "contests#index"
  resources :pending_contests, only: [:index]
  resources :past_contests, only: [:index]

  resources :contests do
    resources :entries do
      member do
        post :rate
        delete :remove
        get :pick_winning
      end
      resources :feedbacks, only: [:new, :create, :edit, :update, :destroy]
    end
  end
end
