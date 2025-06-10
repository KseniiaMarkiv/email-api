class Api::V1::SubscribersController < ApplicationController
  def create
    subscriber = Subscriber.find_by(email: params[:email])
    if subscriber
      render json: { message: 'Email already subscribed' }, status: :unprocessable_entity
    else
      subscriber = Subscriber.new(email: params[:email])
      if subscriber.save
        render json: { message: 'Subscribed successfully' }, status: :created
      else
        render json: { message: 'Subscription failed' }, status: :unprocessable_entity
      end
    end
  end
end
