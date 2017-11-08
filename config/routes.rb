Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :vote_reset
    end
  end

  concern :commentable do
    resources :comments
  end

  resources :questions, concerns: [:votable, :commentable], shallow: true do
    resources :answers do
      concerns [:votable, :commentable]
      patch :choose_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :users, on: :collection
      end

      resources :questions do
        resources :answers
      end
    end
  end

  match '/users/email_confirmation', to: 'users#email_confirmation', via: [:get, :patch], as: 'email_confirmation'

  mount ActionCable.server => '/cable'
end
