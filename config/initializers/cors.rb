allowed_origins = [
  "http://localhost:5173",
  "https://myglassstyle.com"
]

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*allowed_origins)
    resource "*",
      headers: :any,
      methods: [:get, :post, :options]
  end
end
