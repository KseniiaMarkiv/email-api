class GalleryController < ApplicationController
  def show
    folder = params[:folder].capitalize # e.g., Showers, Mirrors

    # Fetch images from Cloudinary
    images = Cloudinary::Api.resources(
      type: "upload",
      resource_type: "image",
      prefix: "#{folder}/",
      max_results: 100
    )["resources"]

    # Fetch videos from Cloudinary
    videos = Cloudinary::Api.resources(
      type: "upload",
      resource_type: "video",
      prefix: "#{folder}/",
      max_results: 100
    )["resources"]

    # Combine images and videos
    resources = images + videos

    # Set caching for this API response (clients & proxies)
    expires_in 1.year, public: true

    render json: resources.map do |res|
      {
        url: res["secure_url"],
        public_id: res["public_id"],
        format: res["format"],
        width: res["width"],
        height: res["height"],
        resource_type: res["resource_type"] # add resource_type to distinguish video/image
      }
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
end
