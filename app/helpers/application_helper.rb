module ApplicationHelper
  def subscription_billing_amount_label(subscription)
    amount = number_to_currency(subscription.amount, precision: currency_precision(subscription.amount))

    case subscription.billing_cycle
    when "yearly"
      monthly_amount = subscription.amount / 12
      "#{amount} /year • #{number_to_currency(monthly_amount, precision: currency_precision(monthly_amount))} /month"
    when "weekly"
      monthly_amount = subscription.amount * 52 / 12
      "#{amount} weekly • #{number_to_currency(monthly_amount, precision: currency_precision(monthly_amount))}/month"
    else
      "#{amount} /month"
    end
  end

  private

  def currency_precision(amount)
    amount.to_f.round == amount.to_f ? 0 : 2
  end
end
