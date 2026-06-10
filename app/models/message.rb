class Message < ApplicationRecord
  belongs_to :chat

  validates :content, :role, presence: true
end
