class CreateSharedSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :shared_subscriptions do |t|
      t.integer :shared_with_user_id
      t.string :permission
      t.string :status
      t.string :shared_with
      t.references :subscription, null: false, foreign_key: true

      t.timestamps
    end
  end
end
