class CreateSubscriptionPriceChanges < ActiveRecord::Migration[8.1]
  def change
    create_table :subscription_price_changes do |t|
      t.references :subscription, null: false, foreign_key: true
      t.decimal :old_amount
      t.decimal :new_amount
      t.date :changed_at

      t.timestamps
    end
  end
end
