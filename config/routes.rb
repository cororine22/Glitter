Rails.application.routes.draw do
  get 'tweet/new'
  post 'tweet/create'

  get '/confirm/:id', to: 'tweet#confirm', as: :confirm

  resources :posts, only: [:create, :edit, :update] # edit,updateを追加
  root to: "tweet#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
