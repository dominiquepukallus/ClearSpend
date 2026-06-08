require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "dashboard@example.com",
      password: "password123",
      first_name: "Dashboard",
      last_name: "User",
      alias: "dashuser"
    )
    @category = Category.create!(name: "Software & Productivity")
  end

  test "calculates monthly spend and cancellations for the selected month" do
    create_subscription(
      name: "Monthly Active",
      amount: 10,
      billing_cycle: "monthly",
      date_recurrence: Date.new(2026, 5, 8)
    )
    create_subscription(
      name: "Yearly Active",
      amount: 120,
      billing_cycle: "yearly",
      date_recurrence: Date.new(2026, 5, 12)
    )
    create_subscription(
      name: "June Active",
      amount: 20,
      billing_cycle: "monthly",
      date_recurrence: Date.new(2026, 6, 8)
    )
    create_subscription(
      name: "Disney Plus",
      amount: 18,
      billing_cycle: "monthly",
      status: "cancelled",
      date_recurrence: Date.new(2026, 5, 10),
      cancelled_at: Time.zone.local(2026, 5, 15, 12)
    )
    create_subscription(
      name: "Annual Design Tool",
      amount: 120,
      billing_cycle: "yearly",
      status: "cancelled",
      date_recurrence: Date.new(2026, 5, 2),
      cancelled_at: Time.zone.local(2026, 5, 22, 12)
    )
    create_subscription(
      name: "Previous Canceled",
      amount: 30,
      billing_cycle: "monthly",
      status: "cancelled",
      date_recurrence: Date.new(2026, 4, 10),
      cancelled_at: Time.zone.local(2026, 4, 20, 12)
    )

    assert_dashboard_totals(
      month: "2026-05",
      monthly_spend: 20,
      canceled_spend: 138,
      breakdown_total: 20,
      monthly_spend_trend: [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20 ],
      added_count: 4,
      canceled_count: 2,
      added_names: [ "Annual Design Tool", "Monthly Active", "Disney Plus", "Yearly Active" ],
      canceled_names: [ "Disney Plus", "Annual Design Tool" ]
    )
  end

  test "defaults to current month when month param is invalid" do
    controller = DashboardController.new
    controller.params = ActionController::Parameters.new(month: "not-a-month")

    assert_equal Date.current.beginning_of_month, controller.send(:selected_month)
  end

  private

  def assert_dashboard_totals(
    month:,
    monthly_spend:,
    canceled_spend:,
    breakdown_total:,
    monthly_spend_trend:,
    added_count:,
    canceled_count:,
    added_names:,
    canceled_names:
  )
    controller = DashboardController.new
    selected_month = Date.strptime(month, "%Y-%m").beginning_of_month
    controller.instance_variable_set(:@selected_month, selected_month)
    controller.instance_variable_set(:@month_range, selected_month.all_month)
    controller.instance_variable_set(
      :@month_time_range,
      selected_month.all_month.first.beginning_of_day..selected_month.all_month.last.end_of_day
    )

    active_subscriptions = controller.send(:active_in_period, @user.subscriptions)
    canceled_subscriptions = controller.send(:canceled_in_period, @user.subscriptions)
    added_subscriptions = controller.send(:added_in_period, @user.subscriptions)
    breakdown = controller.send(:normalized_spend_by_category, active_subscriptions)
    trend = controller.send(:monthly_spend_trend, @user.subscriptions)

    calculated_monthly_spend = controller.send(:normalized_monthly_spend, active_subscriptions)

    assert_equal monthly_spend, calculated_monthly_spend
    assert_equal canceled_spend, controller.send(:total_spend, canceled_subscriptions)
    assert_equal breakdown_total, breakdown.values.sum
    assert_equal monthly_spend_trend, trend.map { |month| month[:value] }
    assert_equal added_count, added_subscriptions.count
    assert_equal canceled_count, canceled_subscriptions.count
    assert_equal added_names, added_subscriptions.map(&:name)
    assert_equal canceled_names, canceled_subscriptions.order(:cancelled_at, :name).map(&:name)
  end

  def create_subscription(attributes)
    Subscription.create!(
      {
        user: @user,
        category: @category,
        status: "active"
      }.merge(attributes)
    )
  end
end
