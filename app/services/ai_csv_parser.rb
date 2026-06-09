class AiCsvParser
  def initialize(csv_content)
    @csv_content = csv_content.force_encoding('UTF-8')
    @categories = Category.pluck(:name)
  end

  def parse
    ai_response = ai_to_parse
    parsed = JSON.parse(ai_response, symbolize_names: true)

    parsed.map do |subscription|
      subscription[:category] = find_category(subscription[:category])
      subscription[:domain_name] = normalize_domain_name(subscription[:domain_name])
      subscription
    end
  end

  private

  def ai_to_parse
    # Create a chat instance
    llm = RubyLLM.chat

    # Ask the question and get response
    response = llm.ask(parse_prompt)

    # Return the content
    response.content
  end

  def parse_prompt
    <<~PROMPT
      You are a helpful assistant that parses CSV files containing subscription information.

      I have a CSV file with subscription data. Please extract the information and return it as a JSON array.

      You MUST use one of these categories (case-sensitive):
      #{@categories.map { |cat| "- #{cat}" }.join("\n")}

      Return format (JSON array only, no other text):
      [
        {
          "name": "Netflix",
          "amount": 22.99,
          "billing_cycle": "monthly",
          "date_recurrence": "2024-06-15",
          "category": "Entertainment",
          "domain_name": "netflix.com"
        }
      ]

      Rules:
      - billing_cycle must be EXACTLY: "weekly", "monthly", or "yearly" (lowercase)
      - date_recurrence must be YYYY-MM-DD format
      - category must match EXACTLY one from the list above (including capitalization)
      - domain_name must be the subscription company's root domain only, like "netflix.com", "spotify.com", or "openai.com"
      - domain_name must not include https://, www., paths, or query strings
      - amount must be a number (no dollar signs)
      - If you can't find a value, make your best guess based on the subscription name
      - Only include items that are clearly recurring subscriptions (ignore one-time purchases)

      Category Selection Guide:
      - Netflix, Spotify, Disney+, Apple Music → "Entertainment"
      - Gym, fitness apps, meditation → "Well-being"
      - Adobe, Microsoft 365, Google Workspace, iCloud → "Software & Productivity"
      - HelloFresh, meal delivery → "Food & Delivery / Meal kits"
      - LinkedIn Premium → "Software & Productivity"
      - If unsure → "Customized"

      Here is the CSV content:

      #{@csv_content}
    PROMPT
  end

  def find_category(ai_category)
    return "Customized" if ai_category.blank?
    return ai_category if @categories.include?(ai_category)

    match = @categories.find { |cat| cat.downcase == ai_category.downcase }
    return match if match

    case ai_category.downcase
    when /music|audio|spotify|apple music/
      "Entertainment"
    when /video|streaming|netflix|disney|hulu/
      "Entertainment"
    when /fitness|health|gym|meditation/
      "Well-being"
    when /news|magazine|newspaper/
      "News & Information"
    when /food|meal|delivery|hellofresh/
      "Food & Delivery / Meal kits"
    when /software|cloud|storage|workspace|productivity|adobe|microsoft/
      "Software & Productivity"
    when /shopping|retail|amazon prime/
      "Shopping & Retail"
    when /linkedin|professional|career/
      "Software & Productivity"
    else
      "Customized"
    end
  end

  def normalize_domain_name(domain_name)
    return nil if domain_name.blank?

    domain_name
      .to_s
      .downcase
      .sub(/\Ahttps?:\/\//, "")
      .sub(/\Awww\./, "")
      .split("/")
      .first
      .to_s
      .split("?")
      .first
      .presence
  end
end
