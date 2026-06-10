class Chats < ActiveRecord::Migration[8.1]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.datetime :chat_date

      t.timestamps
    end
  end
end
