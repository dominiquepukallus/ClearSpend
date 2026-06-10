class ToolRegistry
  TOOLS = [
    GetAllSubscriptions,
    GetUpcomingBills,
    GetAccountInsights,
    GetAddSubscriptionLink
  ].freeze

  def self.register_all(llm_instance)
    TOOLS.each do |tool_class|
      llm_instance.with_tool(tool_class.new)
    end
  end
end
