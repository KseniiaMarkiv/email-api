# frozen_string_literal: true

class GalleryController < ApplicationController
  require "imagekitio"

  def show
    folder_key = params[:folder].to_s.downcase  # normalize the incoming folder param
    folder     = folder_key.capitalize

    cache_key = "imagekit_gallery_data_#{folder}"

    resources = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      imagekit = ImageKitIo::Client.new(
        ENV["IMAGEKIT_PRIVATE_KEY"],
        ENV["IMAGEKIT_PUBLIC_KEY"],
        ENV["IMAGEKIT_URL_ENDPOINT"]
      )

      list = imagekit.list_files(
        path: "/#{folder}/",
        sort:   "ASC_CREATED",
        limit:  100
      )

      list[:response] || []
    end

    expires_in 1.year, public: true
    render json: resources.map { |res| format_resource(res) }
  rescue StandardError => e
    Rails.logger.error "GalleryController#show error: #{e.message}"
    render json: { error: "An internal server error occurred." }, status: 500
  end

  private

  def format_resource(res)
    {
      url:       res["url"],
      file_id:   res["fileId"],
      file_type: res["fileType"],
      format:    res["fileType"],
      width:     res["width"],
      height:    res["height"],
      name:      res["name"]
    }
  end
end
