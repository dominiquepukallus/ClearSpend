# app/services/ai_csv_parser.rb
class AiCsvParser
  def initialize(csv_content)
    @csv_content = csv_content
    @categories = Category.pluck(:name)
  end

  def parse
    ai_response = ai_to_parse
    JSON.parse(ai_response, symbolize_names: true)
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

      Available categories (you MUST use one of these exactly):
      #{@categories.join(', ')}

      Return format (JSON array only, no other text):
      [
        {
          "name": "Netflix",
          "amount": 22.99,
          "billing_cycle": "monthly",
          "date_recurrence": "2024-06-15",
          "category": "Entertainment"
        }
      ]

      Rules:
      - billing_cycle must be EXACTLY: "weekly", "monthly", or "yearly" (lowercase)
      - date_recurrence must be YYYY-MM-DD format
      - category must match EXACTLY one from the list above (including capitalization)
      - amount must be a number (no dollar signs)
      - If you can't find a value, make your best guess based on the subscription name

      Here is the CSV content:

      #{@csv_content}
    PROMPT
  end
end
