MagicWord::Engine.routes.draw do
  match '/validations' => 'validations#show', via: [:put, :post, :get]
end

Rails.application.routes.draw do
  mount MagicWord::Engine, at: '/magic_word'
end
