class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :shared_subscriptions, dependent: :destroy
  has_many :insights, dependent: :destroy

  validates :name, :date_recurrence, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :billing_cycle, presence: true, inclusion: { in: %w[weekly monthly yearly] }
  validates :status, presence: true, inclusion: { in: %w[active cancelled paused] }
end
