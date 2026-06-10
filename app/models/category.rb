class Category < ApplicationRecord
  has_many :subscriptions
  has_many :insights
  has_many :shared_subscriptions, through: :subscriptions

  validates :name, presence: true

  def self.find_by_name_case_insensitive(name)
    find_by("LOWER(name) = ?", name.downcase)
  end

  def color
    case name
    when "Entertainment" then "bg-[#7C3AED] text-white"
    when "Well-being" then "bg-[#4CAF7D] text-white"
    when "News & Information" then "bg-[#0F766E] text-white"
    when "Food & Delivery / Meal kits" then "bg-[#F97316] text-white"
    when "Software & Productivity" then "bg-[#2563EB] text-white"
    when "Shopping & Retail" then "bg-[#EC4899] text-white"
    when "Customized" then "bg-[#4B5563] text-white"
    else "bg-gray-100 text-gray-700"
    end
  end

  def hex_color
    case name
    when "Entertainment" then "#7C3AED"
    when "Well-being" then "#4CAF7D"
    when "News & Information" then "#0F766E"
    when "Food & Delivery / Meal kits" then "#F97316"
    when "Software & Productivity" then "#2563EB"
    when "Shopping & Retail" then "#EC4899"
    when "Customized" then "#4B5563"
    else "#9CA3AF"
    end
  end
end
