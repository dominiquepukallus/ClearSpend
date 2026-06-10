module ApplicationHelper
  def subscription_billing_amount_label(subscription)
    amount = number_to_currency(subscription.amount, precision: currency_precision(subscription.amount))
    monthly_equivalent(subscription, amount)
  end

  def subscription_logo_url(subscription)
    subscription.domain_name.present? ? "https://cdn.brandfetch.io/#{subscription.domain_name}/w/40/h/40" : nil
  end

  private

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
