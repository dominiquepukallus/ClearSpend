class DashboardController < ApplicationController
  # skip_before_action :authenticate_user!, only: :home

  def index
    # Get the data of subscriptions from database
    @subscriptions = current_user.subscriptions.includes(:category)
    @selected_month = selected_month
    @month_range = @selected_month.all_month
    @month_time_range = @month_range.first.beginning_of_day..@month_range.last.end_of_day
    active_subscriptions = active_in_period(@subscriptions)
    canceled_subscriptions = canceled_in_period(@subscriptions)

    @monthly_spend = normalized_monthly_spend(active_subscriptions)
    @canceled_subscriptions = total_spend(canceled_subscriptions)
    @added_subscriptions = added_in_period(@subscriptions)
    @canceled_subscription_details = canceled_subscriptions.includes(:category).order(:cancelled_at, :name)
    @subscription_breakdown = normalized_spend_by_category(active_subscriptions)
    @subscription_breakdown_total = @subscription_breakdown.values.sum
    @monthly_spend_trend = monthly_spend_trend(@subscriptions)
    @insights = current_user.insights.order(created_at: :desc)
  end

  private

  def selected_month
    return Date.current.beginning_of_month if params[:month].blank?

    Date.strptime(params[:month], "%Y-%m").beginning_of_month
  rescue ArgumentError
    Date.current.beginning_of_month
  end

  def active_in_period(subscriptions)
    subscriptions
      .where.not(status: "paused")
      .where("date_recurrence <= ?", @month_range.last)
      .where("status = ? OR cancelled_at IS NULL OR cancelled_at > ?", "active", @month_time_range.last)
  end

  def active_in_month(subscriptions, month)
    month_range = month.all_month
    month_time_range = month_range.first.beginning_of_day..month_range.last.end_of_day

    subscriptions
      .where.not(status: "paused")
      .where("date_recurrence <= ?", month_range.last)
      .where("status = ? OR cancelled_at IS NULL OR cancelled_at > ?", "active", month_time_range.last)
  end

  def canceled_in_period(subscriptions)
    subscriptions
      .where(status: "cancelled")
      .where(cancelled_at: @month_time_range)
  end

  def added_in_period(subscriptions)
    subscriptions
      .where(date_recurrence: @month_range)
      .includes(:category)
      .order(:date_recurrence, :name)
  end

  def normalized_monthly_spend(subscriptions)
    monthly_spend = subscriptions.where(billing_cycle: "monthly").sum(:amount)
    yearly_spend = subscriptions.where(billing_cycle: "yearly").sum(:amount) / 12
    weekly_spend = subscriptions.where(billing_cycle: "weekly").sum(:amount) * 52 / 12

    monthly_spend + yearly_spend + weekly_spend
  end

  def total_spend(subscriptions)
    subscriptions.sum(:amount)
  end

  def monthly_spend_trend(subscriptions, months: 12)
    end_month = [@selected_month, Date.current.beginning_of_month].max
    (months - 1).downto(0).map do |month_offset|
      month = end_month.advance(months: -month_offset).beginning_of_month

      {
        label: month.strftime("%b"),
        full_label: month.strftime("%B %Y"),
        value: normalized_monthly_spend(active_in_month(subscriptions, month)).to_f
      }
    end
  end

  def normalized_spend_by_category(subscriptions)
    subscriptions
      .joins(:category)
      .group("categories.name", :billing_cycle)
      .sum(:amount)
      .each_with_object(Hash.new(0)) do |((category, billing_cycle), amount), totals|
        totals[category] += normalize_monthly_amount(amount, billing_cycle)
      end
  end

  def normalize_monthly_amount(amount, billing_cycle)
    case billing_cycle
    when "yearly"
      amount / 12
    when "weekly"
      amount * 52 / 12
    else
      amount
    end
  end
end
