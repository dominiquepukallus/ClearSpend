class InsightsController < ApplicationController
  def index
    @insights = current_user.insights.includes(:category, :subscription).order(created_at: :desc)
  end
end
