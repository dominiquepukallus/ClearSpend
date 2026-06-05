class InsightsController < ApplicationController
  def index
    @categories = current_user.categories.includes(:subscriptions)
    @categories.each do |category|
      ai_insight(category) unless category.insights.exists?
    end
    @insights = current_user.insights.includes(:category, :subscription)
  end

  private

  def ai_insights

  end
end
