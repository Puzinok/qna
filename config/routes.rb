Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      patch :choose_best
    end
    member do
      post :vote_for
      post :vote_against
      delete :vote_reset
    end
  end

  resources :attachments, only: [:destroy]
end
