class NotificationsController < ApplicationController
  def accept
    @notification = current_user.notifications.find(params[:id])
    shared_sub_id = @notification.params[:shared_subscription][:id]
    @shared_subscription = SharedSubscription.find(shared_sub_id)
    if @shared_subscription.user_id == current_user.id && @shared_subscription.status == 'pending'
      @shared_subscription.update(status: 'accepted')
      @notification.update(read_at: Time.current)
      redirect_back(fallback_location: root_path, flash: { notice: "Subscription accepted!", subscription_id: @shared_subscription.id} )
    else
      redirect_back(fallback_location: root_path, alert: "Unable to accept, please try again")
    end
  end

  def reject
    if @shared_subscription.user_id == current_user.id && @shared_subscription.status == 'pending'
      @shared_subscription.update(status: 'rejected')
      @notification.update(read_at: Time.current)
    redirect_back(fallback_location: root_path, notice: "Subscription rejected!")
    else
      redirect_back(fallback_location: root_path, alert: "Unable to reject, please try again")
    end
  end
end
