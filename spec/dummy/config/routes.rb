Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount MagicWord::Engine => '/magic_word'

  resources :movies
end
