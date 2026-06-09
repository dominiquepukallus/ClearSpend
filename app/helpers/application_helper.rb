module ApplicationHelper
  SUBSCRIPTION_DOMAINS = {
    "Disney Plus" => "disneyplus.com",
    "ChatGPT Plus" => "openai.com",
    "GitHub Copilot" => "github.com",
    "Apple Fitness Plus" => "apple.com",
    "Uber One" => "uber.com",
    "DoorDash DashPass" => "doordash.com",
    "The New York Times" => "nytimes.com",
    "The Economist" => "economist.com",
    "Local Studio Membership" => "yourlocalstudio.com",
    "Costco Membership" => "costco.com",
    "Walmart Plus" => "walmart.com",
    "Instacart Plus" => "instacart.com",
    "Blue Apron" => "blueapron.com",
    "Canva Pro" => "canva.com"
  }.freeze

  def subscription_billing_amount_label(subscription)
    amount = number_to_currency(subscription.amount, precision: currency_precision(subscription.amount))
    monthly_equivalent(subscription, amount)
  end

  def subscription_logo_url(subscription_or_name)
    name = subscription_or_name.respond_to?(:name) ? subscription_or_name.name : subscription_or_name
    domain_name = subscription_or_name.respond_to?(:domain_name) ? subscription_or_name.domain_name : nil

    return nil if domain_name.blank? && SUBSCRIPTION_DOMAINS[name].nil? && SUBSCRIPTION_DOMAINS.key?(name)

    domain = domain_name.presence || SUBSCRIPTION_DOMAINS[name] || name_to_domain(name)
    "https://cdn.brandfetch.io/#{domain}/w/40/h/40"
  end

  private

  def name_to_domain(name)
    cleaned = name
              .downcase
              .gsub(/\s*(plus|pro|app|premium|one|membership|pass)\s*/, "")
              .gsub(/[^a-z0-9]/, "")
              .strip
    "#{cleaned}.com"
  end

  def monthly_equivalent(subscription, amount)
    case subscription.billing_cycle
    when "yearly"
      monthly_amount = subscription.amount / 12
      "#{amount}/year • #{number_to_currency(monthly_amount, precision: currency_precision(monthly_amount))}/month"
      monthly = number_to_currency(subscription.amount / 12, precision: 0)
      "#{amount} /year • #{monthly} /month"
    when "weekly"
      monthly = number_to_currency(subscription.amount * 52 / 12, precision: 0)
      "#{amount} weekly • #{monthly}/month"
    else
      "#{amount}/month"
    end
  end

  def monthly_amount(subscription)
    case subscription.billing_cycle
    when "yearly"
      subscription.amount / 12.0
    when "weekly"
      subscription.amount * 52 / 12.0
    else
      subscription.amount
    end
  end

  def currency_precision(amount)
    (amount % 1).zero? ? 0 : 2
  end
end
