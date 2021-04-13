Rails.application.routes.draw do
  devise_for :installs
  get 'posts/index'
  root to: "posts#index"
end
