class GetAllSubscriptions < RubyLLM::Tool
  desc "Get all the user's active subscriptions with names, amounts, and links"

  param :user_id,
        type: :integer,
        desc: "The user's ID"

  def execute(user_id:)
    user = User.find(user_id)
    subscriptions = user.subscriptions.where(cancelled_at: nil)

    {
      total_monthly: subscriptions.sum(:amount).to_f,
      count: subscriptions.count,
      subscriptions: subscriptions.map do |sub|
        {
          id: sub.id,
          name: sub.name,
          amount: sub.amount.to_f,
          url: Rails.application.routes.url_helpers.subscription_path(sub)
        }
      end,
      add_new_url: Rails.application.routes.url_helpers.new_subscription_path
    }
  end
end
