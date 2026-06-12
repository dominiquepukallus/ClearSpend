class SubscriptionPriceChange < ApplicationRecord
  belongs_to :subscription
  has_many :price_changes, class_name: "SubscriptionPriceChange"

  def difference
    new_amount - old_amount
  end
end
