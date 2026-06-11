class Message < ApplicationRecord
  belongs_to :chat

  validates :content, :role, presence: true

  after_create :update_chat_title_if_first_message

  private

  def update_chat_title_if_first_message
    if role == "user" && chat.messages.where(role: "user").count == 1
      chat.update(title: content.truncate(50, omission: "..."))
    end
  end
end
