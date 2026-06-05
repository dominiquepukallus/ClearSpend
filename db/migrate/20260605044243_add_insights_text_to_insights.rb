class AddInsightsTextToInsights < ActiveRecord::Migration[8.1]
  def change
    add_column :insights, :insight_text, :text
  end
end
