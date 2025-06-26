class GalleryController < ApplicationController
  def show
    folder = params[:folder].capitalize # e.g., Showers, Mirrors

    resources = Cloudinary::Api.resources(
      type: "upload",
      prefix: "#{folder}/",
      max_results: 100
    )

    # Set caching for this API response (clients & proxies)
    expires_in 1.year, public: true

    render json: resources["resources"].map do |img|
      {
        url: img["secure_url"],
        public_id: img["public_id"],
        format: img["format"],
        width: img["width"],
        height: img["height"]
      }
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
end
