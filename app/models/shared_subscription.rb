class SharedSubscription < ApplicationRecord
  belongs_to :subscription
  belongs_to :user

  validates :permission, presence: true, inclusion: { in: %w[read edit] }
  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }
  validates :share_percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  after_create :send_invite_notification
  private

  def send_invite_notification
    SharedSubscriptionNotifier.with(shared_subscription: self, sender: subscription.user).deliver_later(user)
  end
end
