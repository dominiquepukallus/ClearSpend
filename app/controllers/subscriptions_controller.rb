class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.all
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.user = current_user
    if @subscription.save
      redirect_to subscriptions_path, notice: "Subscription created"
    else
      render "subscriptions/new", status: unprocessable_entity
    end
  end

  def edit
    @subscription = Subscription.find(params[:id])
  end

  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.update
      redirect_to subscriptions_path, notice: "Subscription updated"
    else
      render :edit, status: unprocessable_entity
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to subscriptions_path
  end

  private

  def subscription_params
    params.require(:subscription).permit(:name, :date_recurrence, :amount, :billing_cycle, :status)
  end
end
