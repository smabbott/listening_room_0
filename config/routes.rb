Rails.application.routes.draw do
  get "/", controller: :rooms, action: :index
end