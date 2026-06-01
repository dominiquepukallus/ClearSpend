class SharedSubscription < ApplicationRecord
  belongs_to :subscription

  validates :permission, presence: true, inclusion: { in: %w[read edit] }
  validates :status, presence: true, inclusion: { in: %w[pending accepted] }
end
