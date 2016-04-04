Comply::Engine.routes.draw do
  match '/validations' => 'validations#show', via: [:get]
  # allow CORS requests
  match 'validations', via: [:options], to: proc { [200, {}, ['']] }
end
