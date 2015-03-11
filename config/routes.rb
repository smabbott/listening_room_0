Rails.application.routes.draw do
  get "/", controller: :rooms, action: :index
  get "voices/:id", controller: :voices, action: :delete
  post "voices/presence_event", controller: :voices, action: :presence_event
  post "/pusher/auth", controller: :pusher, action: :auth 
end