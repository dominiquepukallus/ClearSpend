class SharedSubscriptionsController < ApplicationController
  before_action :set_shared_subscription, only: %i[accept reject]

  def index
    @received_shares = SharedSubscription.includes(subscription: [:user, :category]).where(user_id: current_user).order(created_at: :desc)
    @sent_shares = current_user.subscriptions.joins(:shared_subscriptions).includes(:shared_subscriptions => :user).distinct
  end

  def accept
    if @shared_subscription.user_id == current_user.id && @shared_subscription.status == 'pending'
      @shared_subscription.update(status: 'accepted')
      redirect_to shared_subscriptions_path, notice: "Subscription accepted!"
    else
      redirect_to shared_subscriptions_path, alert: "Unable to accept, please try again"
    end
  end

  def reject
    if @shared_subscription.user_id == current_user.id && @shared_subscription.status == 'pending'
      @shared_subscription.destroy
    redirect_to shared_subscriptions_path, notice: "Shared Subscription rejected"
    else
      redirect_to shared_subscriptions_path, alert: "Unable to reject, please try again"
    end
  end

  private


  def set_shared_subscription
    @shared_subscription = SharedSubscription.find(params[:id])
  end
end
