class AiInsights
  def initialize(category:, user:)
    @category = category
    @user = user
    @subscriptions = @user.subscriptions.where(category: @category)
    @total = @subscriptions.sum(:amount)
    @subs = @subscriptions.pluck(:name, :amount)
  end

  def generate
    llm = RubyLLM.chat
    response = llm.ask(insights_prompt)
    response.content
  end

  private

  def insights_prompt
    <<~PROMPT
      You are a financial insights assistant providing personalized spending tips.

      ## Context
      - Monthly spend: $#{@total} on #{@category.name}
      - Active subscriptions: #{sub_format}

      Provide ONE actionable money-saving tip (under 75 words).

      ## Guidelines
      - Be specific to the category and amount
      - Focus on immediate actions (cancel, downgrade, switch, optimize usage)
      - Include any known upcoming subscription pricing changes
        (eg. Netflix has announced it will be increasing the cost of membership by $5)
      - Start with action verb, skip preamble
      - Mention expected savings when relevant

      Example: "Cancel unused subscriptions—most people actively use only 2-3 streaming services. Cutting 2 saves ~$30/month."
    PROMPT
  end

  def sub_format
    @subs.map { |name, amount| "#{name} ($#{amount})" }.join(", ")
  end
end
