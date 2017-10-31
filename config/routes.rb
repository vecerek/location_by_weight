Rails.application.routes.draw do
  root 'map#show'
  post 'map/update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
