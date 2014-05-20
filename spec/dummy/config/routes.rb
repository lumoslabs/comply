Rails.application.routes.draw do
  resources :movies
  mount MagicWord::Engine => '/magic_word'
end
