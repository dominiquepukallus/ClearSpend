class Category < ApplicationRecord
  has_many :subscriptions
  has_many :insights
  has_many :shared_subscriptions, through: :subscriptions

  validates :name, presence: true
  def self.find_by_name_case_insensitive(name)
    find_by("LOWER(name) = ?", name.downcase)
  end
end
