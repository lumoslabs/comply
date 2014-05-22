MagicWord::Engine.routes.draw do
  match '/validations' => 'validations#show', via: :get
end
