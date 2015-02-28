Rails.application.routes.draw do
  get "/", controller: :rooms, action: :index
  get "ips/:id", controller: :ips, action: :delete
  post "ips/presence_event", controller: :ips, action: :presence_event
  post "/pusher/auth", controller: :pusher, action: :auth 
end