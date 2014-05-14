MagicWord::Engine.routes.draw do
  match '/validations' => 'validations#create', via: :post
end

Rails.application.routes.draw do
  mount MagicWord::Engine, at: '/magic_word'
end
