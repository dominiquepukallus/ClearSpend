require "test_helper"

class InsightsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      first_name: "Alex",
      last_name: "Spend",
      alias: "alexspend",
      email: "alex@example.com",
      password: "password123"
    )
    @category = Category.create!(name: "Entertainment")
    @subscription = @user.subscriptions.create!(
      name: "Streamly",
      amount: 15,
      billing_cycle: "monthly",
      date_recurrence: Date.current,
      status: "active",
      category: @category
    )

    sign_in @user
  end

  test "generate creates missing insights and redirects back" do
    with_stubbed_ai_insights("Cancel one unused service to save $15/month.") do
      assert_difference("Insight.count", 1) do
        post generate_insights_path, params: { return_to: dashboard_path }
      end
    end

    assert_redirected_to dashboard_path
    assert_equal "Cancel one unused service to save $15/month.", @user.insights.last.insight_text
  end

  test "generate regenerates categories that already have insights" do
    existing = @user.insights.create!(
      category: @category,
      subscription: @subscription,
      insight_text: "Existing insight"
    )

    with_stubbed_ai_insights("Fresh generated insight") do
      assert_no_difference("Insight.count") do
        post generate_insights_path, params: { return_to: insights_path }
      end
    end

    assert_redirected_to insights_path
    assert_not Insight.exists?(existing.id)
    assert_equal "Fresh generated insight", @user.insights.find_by(category: @category).insight_text
  end

  test "generate replaces the dashboard ai insights frame for turbo stream requests" do
    with_stubbed_ai_insights("Turbo refreshed insight") do
      assert_difference("Insight.count", 1) do
        post generate_insights_path,
             params: { return_to: dashboard_path },
             headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end
    end

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, 'target="dashboard-ai-insights"'
    assert_includes response.body, "Turbo refreshed insight"
  end

  test "regenerate replaces the selected category insight" do
    existing = @user.insights.create!(
      category: @category,
      subscription: @subscription,
      insight_text: "Existing insight"
    )

    with_stubbed_ai_insights("Downgrade this plan to save $5/month.") do
      assert_no_difference("Insight.count") do
        post regenerate_insights_path, params: { category_id: @category.id, return_to: insights_path(category_id: @category.id) }
      end
    end

    assert_redirected_to insights_path(category_id: @category.id)
    assert_not Insight.exists?(existing.id)
    assert_equal "Downgrade this plan to save $5/month.", @user.insights.find_by(category: @category).insight_text
  end

  test "generate falls back when return path is external" do
    with_stubbed_ai_insights("Cancel one unused service.") do
      post generate_insights_path, params: { return_to: "https://example.com/phish" }
    end

    assert_redirected_to insights_path
  end

  private

  def with_stubbed_ai_insights(text)
    original_new = AiInsights.method(:new)
    generator = Struct.new(:text) do
      def generate
        text
      end
    end.new(text)

    AiInsights.define_singleton_method(:new) { |*| generator }
    yield
  ensure
    AiInsights.define_singleton_method(:new) { |*args, **kwargs| original_new.call(*args, **kwargs) }
  end
end
