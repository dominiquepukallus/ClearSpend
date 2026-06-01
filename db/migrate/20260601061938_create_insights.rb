class CreateInsights < ActiveRecord::Migration[8.1]
  def change
    create_table :insights do |t|
      t.references :category, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
