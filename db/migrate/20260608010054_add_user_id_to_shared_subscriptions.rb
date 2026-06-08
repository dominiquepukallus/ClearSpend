class AddUserIdToSharedSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_reference :shared_subscriptions, :user, null: false, foreign_key: true
    add_column :shared_subscriptions, :share_percentage, :decimal
  end
end
