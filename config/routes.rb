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

  resources :questions, concerns: :votable do
    resources :answers, shallow: true do
      concerns :votable
      patch :choose_best
    end
    resources :comments, only: [:create]
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
