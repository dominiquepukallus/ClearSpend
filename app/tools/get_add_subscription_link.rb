class GetAddSubscriptionLink < RubyLLM::Tool
  desc "Get the link to add a new subscription with helpful guidance"

  param :user_id,
        type: :integer,
        desc: "The user's ID"

  def execute(user_id:)
    user = User.find(user_id)
    total_subs = user.subscriptions.where(cancelled_at: nil).count

    {
      url: Rails.application.routes.url_helpers.new_subscription_path,
      current_count: total_subs,
      tips: [
        "Have your bank statement ready for the exact amount",
        "Check when you were last charged to set the billing date",
        "Choose a category to keep things organized"
      ],
      examples: [
        "Netflix - $22/month - Streaming",
        "Spotify - $13/month - Music"
      ]
    }
  end
end
