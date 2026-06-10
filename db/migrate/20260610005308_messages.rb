class Messages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.string :role
      t.text :content
      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end
  end
end
