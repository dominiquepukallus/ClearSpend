class GetUpcomingBills < RubyLLM::Tool
  desc "Get subscriptions billing in the next 30 days with dates and amounts"

  param :user_id,
        type: :integer,
        desc: "The user's ID"

  param :days,
        type: :integer,
        required: false,
        desc: "Number of days to look ahead (default: 30)"

  def execute(user_id:, days: 30)
    user = User.find(user_id)
    all_subscriptions = user.subscriptions.where(cancelled_at: nil).to_a

    upcoming = all_subscriptions.select do |sub|
      next_date = sub.next_billing_date
      next_date.present? && next_date <= days.days.from_now.to_date
    end.sort_by(&:next_billing_date)

    {
      total_due: upcoming.sum(&:amount).to_f,
      count: upcoming.count,
      bills: upcoming.map do |sub|
        {
          name: sub.name,
          amount: sub.amount.to_f,
          date: sub.next_billing_date&.strftime("%B %d"),
          url: Rails.application.routes.url_helpers.subscription_path(sub)
        }
      end
    }
  end
end
