class Category < ApplicationRecord
  has_many :subscriptions
  has_many :insights
  has_many :shared_subscriptions, through: :subscriptions

  validates :name, presence: true
end
