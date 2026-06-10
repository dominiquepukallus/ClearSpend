class GetAccountInsights < RubyLLM::Tool
  desc "Get comprehensive insights and analytics about the user's subscription account"

  param :user_id,
        type: :integer,
        desc: "The user's ID"

  def execute(user_id:)
    user = User.find(user_id)
    subscriptions = user.subscriptions.where(cancelled_at: nil)

    total_monthly = subscriptions.sum(:amount).to_f
    total_yearly = (total_monthly * 12).round(2)

    by_cycle = subscriptions.group(:billing_cycle).count

    by_category = subscriptions.joins(:category).group('categories.name').sum(:amount)

    most_expensive = subscriptions.order(amount: :desc).first

    cancelled_count = user.subscriptions.where.not(cancelled_at: nil).count
    total_saved = user.subscriptions.where.not(cancelled_at: nil).sum(:amount).to_f

    {
      overview: {
        total_active: subscriptions.count,
        total_monthly: total_monthly,
        total_yearly: total_yearly,
        average_per_subscription: (total_monthly / subscriptions.count).round(2)
      },
      breakdown: {
        by_billing_cycle: by_cycle,
        by_category: by_category.transform_values(&:to_f)
      },
      highlights: {
         most_expensive: most_expensive ? {
          name: most_expensive.name,
          amount: most_expensive.amount.to_f,
          url: Rails.application.routes.url_helpers.subscription_path(most_expensive)
        } : nil,
        cancelled_count: cancelled_count,
        total_saved: total_saved
      },
      links: {
        view_all: Rails.application.routes.url_helpers.subscriptions_path,
        add_new: Rails.application.routes.url_helpers.new_subscription_path,
        view_insights: Rails.application.routes.url_helpers.insights_path
      }
    }
  end
end
