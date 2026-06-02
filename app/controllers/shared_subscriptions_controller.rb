class SharedSubscriptionsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_shared_subscription, only: %i[show update destroy]

  def index
    @shared_subscriptions = current_user.shared_subscriptions.includes(:subscription)
  end

  def show
  end

  def new
    @shared_subscription = SharedSubscription.new
  end

  def create
    @shared_subscription = SharedSubscription.new(shared_subscription_params)
    @shared_subscription.user = current_user
    if @shared_subscription.save
      redirect_to subscriptions_path, notice: "Shared Subscription created"
    else
      render "subscriptions/new", status: unprocessable_entity
    end
  end

  private

  def shared_subscription_params
    params.require(:shared_subscription).permit(:permission, :status)
  end

  def set_shared_subscription
    @shared_subscription = Subscription.find(params[:id])
    @subscriptions = @shared_subscription.subscription
    # render only if current user logged in
  end
end
