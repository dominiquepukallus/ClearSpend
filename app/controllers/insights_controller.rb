class InsightsController < ApplicationController
  def index
    @categories = Category.joins(:subscriptions).where(subscriptions: {user: current_user}).distinct.includes(:subscriptions)
    @selected_category = params[:category_id] ? Category.find_by(id: params[:category_id]) : nil
    @insights = current_user.insights.includes(:category, :subscription)
    if params[:category_id].present?
      @selected_category = @categories.find_by(id: params[:category_id])
    else
      @selected_category = @categories.first
    end
  end

  def generate
    categories.each do |category|
      regenerate_insight(category)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "dashboard-ai-insights",
          partial: "dashboard/ai_insights_card",
          locals: { insights: dashboard_insights, return_to: return_path }
        )
      end
      format.html { redirect_to return_path, notice: "Insights generated" }
    end
  end

  def regenerate
    category = categories.find_by(id: params[:category_id])

    if category
      regenerate_insight(category)
      redirect_to return_path, notice: "Insight regenerated"
    else
      redirect_to return_path, alert: "Choose a category with subscriptions to regenerate an insight"
    end
  end

  private

  def categories
    @categories ||= Category.joins(:subscriptions).where(subscriptions: {user: current_user}).distinct
  end

  def dashboard_insights
    current_user.insights.includes(:category).order(created_at: :desc)
  end

  def regenerate_insight(category)
    current_user.insights.where(category: category).destroy_all
    generate_insight(category)
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

  def return_path
    path = params[:return_to].presence || request.referer
    return path if path.present? && internal_path?(path)

    insights_path
  end

  def internal_path?(path)
    uri = URI.parse(path)

    uri.host.nil? && uri.path.present? && uri.path.start_with?("/")
  rescue URI::InvalidURIError, NoMethodError
    false
  end
end
