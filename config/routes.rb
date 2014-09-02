Rails.application.routes.draw do
  get "/", controller: :rooms, action: :index
  get "ips/:id", controller: :ips, action: :delete
  post "/pusher/auth", controller: :pusher, action: :auth 
end