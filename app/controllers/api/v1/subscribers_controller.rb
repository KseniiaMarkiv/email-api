module Api
  module V1
    class SubscribersController < ApplicationController
      def create
        email = params[:email].to_s.downcase

        subscriber = Subscriber.find_by(email: email)

        if subscriber
          render json: { message: "Email already subscribed" }, status: :ok
        else
          subscriber = Subscriber.new(email: email)

          if subscriber.save
            render json: { message: "Subscribed successfully", subscriber: subscriber }, status: :created
          else
            render json: { message: "Failed to subscribe", errors: subscriber.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
