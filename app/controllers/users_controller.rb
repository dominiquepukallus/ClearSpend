class UsersController < ApplicationController
  def show
    @user = current_user
    @active_subscriptions_count = @user.subscriptions.where(status: 'active').count
    @cancelled_subscriptions_count = @user.subscriptions.where(status: 'cancelled').count
    @shared_subscriptions = @user.subscriptions.joins(:shared_subscriptions).includes(:shared_subscriptions => :user).distinct
  end
end
