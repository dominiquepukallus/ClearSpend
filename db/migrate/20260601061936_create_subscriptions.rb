class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.date :date_recurrence
      t.string :billing_cycle
      t.decimal :amount
      t.string :status
      t.datetime :cancelled_at
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
