class SharedSubscriptionsController < ApplicationController
  before_action :set_shared_subscription, only: %i[accept reject]

  def index
    @received_shares = SharedSubscription.includes(subscription: [:user, :category]).where(user_id: current_user).order(created_at: :desc)
    @sent_shares = current_user.subscriptions.joins(:shared_subscriptions).includes(:shared_subscriptions => :user).distinct
    @pending_notifications = current_user.subscriptions.where(type: 'SharedSubscriptionNotifier').unread.order(created_at: :desc)
  end

  def create
    @subscription = current_user.subscriptions.find(params[:subscription_id])
    @shared_subscription = @subscription.shared_subscriptions.build(shared_subscription_params)
    if @shared_subscription.save
      redirect_to shared_subscriptions_path, notice: "Invitation sent!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    if @shared_subscription.user_id == current_user.id && @shared_subscription.status == 'pending'
      @shared_subscription.update(status: 'accepted')
      mark_notification_read(@shared_subscription, 'accepted')
      redirect_to shared_subscriptions_path, notice: "Subscription accepted!"
    else
      redirect_to shared_subscriptions_path, alert: "Unable to accept, please try again"
    end
  end

  def reject
    if @shared_subscription.user_id == current_user.id && @shared_subscription.status == 'pending'
      @shared_subscription.update(status: 'rejected')
      mark_notification_read(@shared_subscription)
    redirect_to shared_subscriptions_path, notice: "Shared Subscription rejected"
    else
      redirect_to shared_subscriptions_path, alert: "Unable to reject, please try again"
    end
  end

  private

  def shared_subscription_params
    params.require(:shared_subscription).permit(:user_id, :permission, :share_percentage, :status)
  end

  def mark_notification_read(shared_subscription, action)
    notification = current_user.notifications.where(type: 'SharedSubscriptionNotifier')
                                              .find_by("params->>'shared_subscription_id' = ?", shared_subscription.id.to_s)
    notification&.update(read_at: Time.current)
  end

  def set_shared_subscription
    @shared_subscription = SharedSubscription.find(params[:id])
  end
end
