Subscription.destroy_all
User.destroy_all
Category.destroy_all

demo_user = User.find_or_initialize_by(email: "demo@clearspend.test")
demo_user.assign_attributes(
  first_name: "Demo",
  last_name: "User",
  alias: "demo_user",
  password: "password",
  password_confirmation: "password"
)
demo_user.save!

puts "User saved"

categories = [
  "Entertainment",
  "Well-being",
  "News & Information",
  "Food & Delivery / Meal kits",
  "Software & Productivity",
  "Shopping & Retail",
  "Customized"
]

puts "Category saved"

category_records = categories.index_with do |category_name|
  Category.find_or_create_by!(name: category_name)
end

demo_month = Date.current.beginning_of_month

subscription_date = lambda do |month_offset, day|
  demo_month.advance(months: month_offset).change(day: day)
end

subscriptions = [
  {
    name: "Netflix",
    category: "Entertainment",
    amount: 22,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 8),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Spotify",
    category: "Entertainment",
    amount: 13,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 14),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Disney Plus",
    category: "Entertainment",
    amount: 140,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(0, 15),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Headspace",
    category: "Well-being",
    amount: 16,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 5),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "ClassPass",
    category: "Well-being",
    amount: 49,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 19),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "The New York Times",
    category: "News & Information",
    amount: 12,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 3),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Blinkist",
    category: "News & Information",
    amount: 10,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 23),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "HelloFresh",
    category: "Food & Delivery / Meal kits",
    amount: 72,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 10),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Uber One",
    category: "Food & Delivery / Meal kits",
    amount: 10,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 17),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Notion",
    category: "Software & Productivity",
    amount: 12,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 2),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "GitHub Copilot",
    category: "Software & Productivity",
    amount: 19,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 21),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Canva Pro",
    category: "Software & Productivity",
    amount: 120,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(0, 11),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Amazon Prime",
    category: "Shopping & Retail",
    amount: 15,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 12),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Costco Membership",
    category: "Shopping & Retail",
    amount: 5,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 27),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Walmart Plus",
    category: "Shopping & Retail",
    amount: 98,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(0, 18),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Local Studio Membership",
    category: "Customized",
    amount: 28,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 25),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Adobe Creative Cloud",
    category: "Software & Productivity",
    amount: 45,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(0, 16),
    status: "cancelled",
    cancelled_at: Date.new(2026, 6, 16)
  },
  {
    name: "Netflix - last month",
    category: "Entertainment",
    amount: 22,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-1, 8),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Disney Plus - last month",
    category: "Entertainment",
    amount: 140,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(-1, 15),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Apple Fitness Plus - last month",
    category: "Well-being",
    amount: 119,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(-1, 4),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "The Economist - last month",
    category: "News & Information",
    amount: 24,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-1, 9),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "DoorDash DashPass - last month",
    category: "Food & Delivery / Meal kits",
    amount: 96,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(-1, 12),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Figma - last month",
    category: "Software & Productivity",
    amount: 15,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-1, 19),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Audible - last month",
    category: "Entertainment",
    amount: 16,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-1, 22),
    status: "cancelled",
    cancelled_at: Date.new(2026, 5, 22)
  },
  {
    name: "Hulu - two months ago",
    category: "Entertainment",
    amount: 18,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-2, 7),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Peloton App - two months ago",
    category: "Well-being",
    amount: 24,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-2, 11),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Medium - two months ago",
    category: "News & Information",
    amount: 60,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(-2, 16),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Blue Apron - two months ago",
    category: "Food & Delivery / Meal kits",
    amount: 68,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-2, 20),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Dropbox - two months ago",
    category: "Software & Productivity",
    amount: 120,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(-2, 24),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Instacart Plus - two months ago",
    category: "Shopping & Retail",
    amount: 99,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(-2, 26),
    status: "cancelled",
    cancelled_at: Date.new(2026, 4, 26)
  },
  {
    name: "Paramount Plus - three months ago",
    category: "Entertainment",
    amount: 12,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-3, 6),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Netflix - cancelled in March",
    category: "Entertainment",
    amount: 22,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-3, 8),
    status: "cancelled",
    cancelled_at: Date.new(2026, 3, 19)
  },
  {
    name: "Calm - three months ago",
    category: "Well-being",
    amount: 70,
    billing_cycle: "yearly",
    date_recurrence: subscription_date.call(-3, 13),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "ChatGPT Plus - three months ago",
    category: "Software & Productivity",
    amount: 20,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-3, 18),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "YouTube Premium - three months ago",
    category: "Entertainment",
    amount: 14,
    billing_cycle: "monthly",
    date_recurrence: subscription_date.call(-3, 28),
    status: "cancelled",
    cancelled_at: Date.new(2026, 3, 28)
  }
]

subscriptions.each do |subscription_attrs|
  subscription = demo_user.subscriptions.find_or_initialize_by(name: subscription_attrs[:name])
  subscription.assign_attributes(
    amount: subscription_attrs[:amount],
    billing_cycle: subscription_attrs[:billing_cycle],
    category: category_records.fetch(subscription_attrs[:category]),
    date_recurrence: subscription_attrs[:date_recurrence],
    status: subscription_attrs[:status],
    cancelled_at: subscription_attrs[:cancelled_at]
  )
  subscription.save!
end

puts "Subscriptions saved"
