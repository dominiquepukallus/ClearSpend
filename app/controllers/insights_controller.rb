class InsightsController < ApplicationController
  def index
    @categories = Category.joins(:subscriptions).where(subscriptions: {user: current_user}).distinct.includes(:subscriptions)

    @categories.each do |category|
      generate_insight(category) unless needs_insights?(category)
    end
    @selected_category = params[:category_id] ? Category.find_by(id: params[:category_id]) : nil
    @insights = current_user.insights.includes(:category, :subscription)
  end

  private

  def needs_insights?(category)
    Insight.exists?(user: current_user, category: category)
  end

  def generate_insight(category)
    user_subs = current_user.subscriptions.where(category: category)
    return if user_subs.sum(:amount).zero?

    insight_text = AiInsights.new(user: current_user, category: category).generate
    Insight.create!(
      user: current_user,
      category: category,
      subscription: user_subs.first,
      insight_text: insight_text
    )
  rescue => e
    Rails.logger.error("Failed to generate insight for #{category.name}: #{e.class} - #{e.message}")
  end
end
