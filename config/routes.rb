Rails.application.routes.draw do
  get "/", controller: :rooms, action: :index
  get "ips/:id", controller: :ips, action: :delete
end