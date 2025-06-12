module Api
  module V1
    class SubscribersController < ApplicationController
      def create
        email = subscriber_params[:email].strip.downcase
        return head :unprocessable_entity if Subscriber.exists?(email: email)

        @subscriber = Subscriber.new(email: email)

        if @subscriber.save
          EmailjsService.send_notification(email)
          head :created
        else
          head :unprocessable_entity
        end
      end

      private

      def subscriber_params
        params.require(:subscriber).permit(:email)
      end
    end
  end
end
