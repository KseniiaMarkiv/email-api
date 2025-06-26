if defined?(Puma)
  Puma::Server.class_eval do
    @default_server_settings = {
      "keep_alive_timeout" => 120_000,
      "first_data_timeout" => 120_000
    }
  end
end
