Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/artists/build', to: 'artists#build_artists'
  get '/artists/data', to: 'artists#get_artists'
end
