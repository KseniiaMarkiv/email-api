# app/services/emailjs_service.rb
require "net/http"
require "uri"
require "json"

class EmailjsService
  def self.send_notification(subscriber_email)
    uri = URI("https://api.emailjs.com/api/v1.0/email/send")

    # Build JSON body
    body = {
      service_id: ENV["EMAILJS_SERVICE_ID"],
      template_id: ENV["EMAILJS_TEMPLATE_ID"],
      user_id: ENV["EMAILJS_USER_ID"],
      accessToken: ENV["EMAILJS_PRIVATE_KEY"],
      template_params: {
        user_email: subscriber_email
      }
    }

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = body.to_json

    # Send request
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    Rails.logger.info "EmailJS Response: #{response.code} - #{response.body}"
  rescue => e
    Rails.logger.error "EmailJS Error: #{e.class.name} - #{e.message}"
  end
end
