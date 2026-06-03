User.destroy_all
Category.destroy_all
Subscription.destroy_all

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

subscriptions = [
  {
    name: "Netflix",
    category: "Entertainment",
    amount: 22,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 8),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Spotify",
    category: "Entertainment",
    amount: 13,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 14),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Headspace",
    category: "Well-being",
    amount: 16,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 5),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "ClassPass",
    category: "Well-being",
    amount: 49,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 19),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "The New York Times",
    category: "News & Information",
    amount: 12,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 3),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Blinkist",
    category: "News & Information",
    amount: 10,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 23),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "HelloFresh",
    category: "Food & Delivery / Meal kits",
    amount: 72,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 10),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Uber One",
    category: "Food & Delivery / Meal kits",
    amount: 10,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 17),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Notion",
    category: "Software & Productivity",
    amount: 12,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 2),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "GitHub Copilot",
    category: "Software & Productivity",
    amount: 19,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 21),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Amazon Prime",
    category: "Shopping & Retail",
    amount: 15,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 12),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Costco Membership",
    category: "Shopping & Retail",
    amount: 5,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 27),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Local Studio Membership",
    category: "Customized",
    amount: 28,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 25),
    status: "active",
    cancelled_at: nil
  },
  {
    name: "Adobe Creative Cloud",
    category: "Software & Productivity",
    amount: 45,
    billing_cycle: "monthly",
    date_recurrence: Date.current.change(day: 16),
    status: "cancelled",
    cancelled_at: 1.day.ago
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
