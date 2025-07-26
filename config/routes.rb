Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :subscribers, only: [ :create ]
    end
  end

  get "/api/gallery/:folder", to: "gallery#show"

  get "*path", to: "static_pages#index", constraints: ->(request) do
    !request.xhr? && request.format.html?
  end
end
