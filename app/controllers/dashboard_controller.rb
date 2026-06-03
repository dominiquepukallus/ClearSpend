class DashboardController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def index
    # Get the data of subscriptions from database
    @subscriptions = current_user.subscriptions.includes(:category)
    @selected_period = selected_period
    @period_range = dashboard_period_range(@selected_period)
    active_subscriptions = period_filtered(@subscriptions.where(status: "active"), :date_recurrence)
    canceled_this_month = @subscriptions.where(
      status: "cancelled",
      cancelled_at: Time.current.all_month
    )

    @monthly_spend = normalized_monthly_spend(active_subscriptions)
    @yearly_spend = @monthly_spend * 12
    @total_subscriptions = active_subscriptions.count
    @canceled_subscriptions = normalized_monthly_spend(canceled_this_month)
    @subscription_breakdown = active_subscriptions.joins(:category).group("categories.name").sum(:amount)
    @subscription_breakdown_total = @subscription_breakdown.values.sum
  end

  private

  def selected_period
    params.fetch(:period, "month")
  end

  def dashboard_period_range(period)
    case period
    when "year"
      Date.current.all_year
    when "all"
      Date.new(2000, 1, 1)..Date.current
    else
      Date.current.all_month
    end
  end

  def period_filtered(subscriptions, column)
    return subscriptions if @selected_period == "all"

    subscriptions.where(column => @period_range)
  end

  def normalized_monthly_spend(subscriptions)
    monthly_spend = subscriptions.where(billing_cycle: "monthly").sum(:amount)
    yearly_spend = subscriptions.where(billing_cycle: "yearly").sum(:amount) / 12
    weekly_spend = subscriptions.where(billing_cycle: "weekly").sum(:amount) * 52 / 12

    monthly_spend + yearly_spend + weekly_spend
  end
end
