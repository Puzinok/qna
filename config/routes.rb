Rails.application.routes.draw do
  devise_for :users
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
      patch :choose_best
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
