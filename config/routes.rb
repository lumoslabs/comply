MagicWord::Engine.routes.draw do
  match '/validations' => 'validations#create', via: :post
end
