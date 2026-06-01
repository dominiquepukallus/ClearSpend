class Category < ApplicationRecord
  has_many :shared_subscriptions, through: :subscriptions
  has many :subscriptions, :insights

  validates :name, presence: true
end
