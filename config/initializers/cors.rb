if Rails.env.development?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "http://localhost:5173"  # Or whatever your dev port is
      resource "*", headers: :any, methods: [ :get, :post, :options ]
    end
  end
end


Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://myglassstyle.com"
    resource "*",
      headers: :any,
      methods: [ :get, :post, :options ]
  end
end
