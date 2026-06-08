class SharedSubscription < ApplicationRecord
  belongs_to :subscription
  belongs_to :user

  validates :permission, presence: true, inclusion: { in: %w[read edit] }
  validates :status, presence: true, inclusion: { in: %w[pending accepted] }
  validates :share_percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end
