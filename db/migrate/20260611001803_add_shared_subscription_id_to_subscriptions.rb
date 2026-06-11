class AddSharedSubscriptionIdToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :shared_subscription_id, :integer
    add_foreign_key :subscriptions, :shared_subscriptions
    add_index :subscriptions, :shared_subscription_id
  end
end
