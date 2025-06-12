Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173" # or your domain later
    resource "*",
      headers: :any,
      methods: [:post, :options]
  end
end
