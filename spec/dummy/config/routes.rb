Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount Comply::Engine => '/comply'

  resources :movies
end
