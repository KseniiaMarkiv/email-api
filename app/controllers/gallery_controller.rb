class GalleryController < ApplicationController
  def show
    folder = params[:folder].capitalize

    cache_key = "cloudinary_gallery_data_#{folder.underscore}"

    resources = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      images = Cloudinary::Api.resources(
        type: "upload",
        resource_type: "image",
        prefix: "#{folder}/",
        max_results: 500
      )["resources"] || []

      videos = Cloudinary::Api.resources(
        type: "upload",
        resource_type: "video",
        prefix: "#{folder}/",
        max_results: 500
      )["resources"] || []

      images + videos
    end

    expires_in 1.year, public: true

    render json: (resources || []).map do |res|
      {
        url: res["secure_url"],
        public_id: res["public_id"],
        format: res["format"],
        width: res["width"],
        height: res["height"],
        resource_type: res["resource_type"]
      }
    end
  rescue => e
    Rails.logger.error "GalleryController#show error: #{e.message}"
    render json: { error: "An internal server error occurred." }, status: 500
  end
end
