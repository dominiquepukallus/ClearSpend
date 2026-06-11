Subscription.destroy_all
Chat.destroy_all
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

demo_shared_user = User.find_or_initialize_by(email: "share@clearspend.test")
demo_shared_user.assign_attributes(
  first_name: "Shared",
  last_name: "User",
  alias: "shared_user",
  password: "password",
  password_confirmation: "password"
)
demo_shared_user.save!
puts "User saved"

categories = [
  "Entertainment",
  "Well-being",
  "News & Information",
  "Food & Delivery / Meal kits",
  "Software & Productivity",
  "Shopping & Retail",
]

categories.each do |name|
  Category.find_or_create_by(name: name)
end

category_records = categories.index_with do |category_name|
  Category.find_or_create_by!(name: category_name)
end
puts "Categories saved"

# date_recurrence = the anchor/start date of the subscription.
# Recurring billing dates are computed from this in the app via billing_cycle.
# Use a realistic past date so history is populated on first seed.

subscriptions = [
  # Entertainment
  { name: "Netflix", domain_name: "netflix.com", category: "Entertainment", amount: 22, billing_cycle: "monthly", date_recurrence: Date.new(2025, 1, 8), status: "active", cancelled_at: nil },
  { name: "Spotify", domain_name: "spotify.com", category: "Entertainment", amount: 13, billing_cycle: "monthly", date_recurrence: Date.new(2025, 2, 14), status: "active", cancelled_at: nil },
  { name: "Disney Plus", domain_name: "disneyplus.com", category: "Entertainment", amount: 140, billing_cycle: "yearly", date_recurrence: Date.new(2025, 6, 15), status: "active", cancelled_at: nil },
  { name: "Hulu", domain_name: "hulu.com", category: "Entertainment", amount: 18, billing_cycle: "monthly", date_recurrence: Date.new(2025, 3, 7), status: "active", cancelled_at: nil },
  { name: "Paramount Plus", domain_name: "paramountplus.com", category: "Entertainment", amount: 12, billing_cycle: "monthly", date_recurrence: Date.new(2025, 3, 6), status: "active", cancelled_at: nil },
  { name: "Audible", domain_name: "audible.com", category: "Entertainment", amount: 16, billing_cycle: "monthly", date_recurrence: Date.new(2025, 4, 22), status: "cancelled", cancelled_at: Date.new(2026, 5, 22) },
  { name: "YouTube Premium", domain_name: "youtube.com", category: "Entertainment", amount: 14, billing_cycle: "monthly", date_recurrence: Date.new(2025, 6, 28), status: "cancelled", cancelled_at: Date.new(2026, 3, 28) },

  # Well-being
  { name: "Headspace", domain_name: "headspace.com", category: "Well-being", amount: 16, billing_cycle: "monthly", date_recurrence: Date.new(2025, 2, 5), status: "active", cancelled_at: nil },
  { name: "ClassPass", domain_name: "classpass.com", category: "Well-being", amount: 49, billing_cycle: "monthly", date_recurrence: Date.new(2025, 4, 19), status: "active", cancelled_at: nil },
  { name: "Apple Fitness Plus", domain_name: "apple.com", category: "Well-being", amount: 119, billing_cycle: "yearly", date_recurrence: Date.new(2025, 5, 4), status: "active", cancelled_at: nil },
  { name: "Peloton App", domain_name: "onepeloton.com", category: "Well-being", amount: 24, billing_cycle: "monthly", date_recurrence: Date.new(2025, 3, 11), status: "active", cancelled_at: nil },
  { name: "Calm", domain_name: "calm.com", category: "Well-being", amount: 70, billing_cycle: "yearly", date_recurrence: Date.new(2025, 3, 13), status: "active", cancelled_at: nil },

  # News & Information
  { name: "The New York Times", domain_name: "nytimes.com", category: "News & Information", amount: 12, billing_cycle: "monthly", date_recurrence: Date.new(2025, 1, 3), status: "active", cancelled_at: nil },
  { name: "Blinkist", domain_name: "blinkist.com", category: "News & Information", amount: 10, billing_cycle: "monthly", date_recurrence: Date.new(2025, 2, 23), status: "active", cancelled_at: nil },
  { name: "The Economist", domain_name: "economist.com", category: "News & Information", amount: 24, billing_cycle: "monthly", date_recurrence: Date.new(2025, 4, 9), status: "active", cancelled_at: nil },
  { name: "Medium", domain_name: "medium.com", category: "News & Information", amount: 60, billing_cycle: "yearly", date_recurrence: Date.new(2025, 4, 16), status: "active", cancelled_at: nil },

  # Food & Delivery / Meal kits
  { name: "HelloFresh", domain_name: "hellofresh.com", category: "Food & Delivery / Meal kits", amount: 72, billing_cycle: "monthly", date_recurrence: Date.new(2025, 1, 10), status: "active", cancelled_at: nil },
  { name: "Uber One", domain_name: "uber.com", category: "Food & Delivery / Meal kits", amount: 10, billing_cycle: "monthly", date_recurrence: Date.new(2025, 3, 17), status: "active", cancelled_at: nil },
  { name: "DoorDash DashPass", domain_name: "doordash.com", category: "Food & Delivery / Meal kits", amount: 96, billing_cycle: "yearly", date_recurrence: Date.new(2025, 5, 12), status: "active", cancelled_at: nil },
  { name: "Blue Apron", domain_name: "blueapron.com", category: "Food & Delivery / Meal kits", amount: 68, billing_cycle: "monthly", date_recurrence: Date.new(2025, 3, 20), status: "active", cancelled_at: nil },

  # Software & Productivity
  { name: "Notion", domain_name: "notion.so", category: "Software & Productivity", amount: 12, billing_cycle: "monthly", date_recurrence: Date.new(2025, 1, 2), status: "active", cancelled_at: nil },
  { name: "GitHub Copilot", domain_name: "github.com", category: "Software & Productivity", amount: 19, billing_cycle: "monthly", date_recurrence: Date.new(2025, 2, 21), status: "active", cancelled_at: nil },
  { name: "Canva Pro", domain_name: "canva.com", category: "Software & Productivity", amount: 120, billing_cycle: "yearly", date_recurrence: Date.new(2025, 6, 11), status: "active", cancelled_at: nil },
  { name: "Adobe Creative Cloud", domain_name: "adobe.com", category: "Software & Productivity", amount: 45, billing_cycle: "monthly", date_recurrence: Date.new(2025, 1, 16), status: "cancelled", cancelled_at: Date.new(2026, 6, 16) },
  { name: "Figma", domain_name: "figma.com", category: "Software & Productivity", amount: 15, billing_cycle: "monthly", date_recurrence: Date.new(2025, 4, 19), status: "active", cancelled_at: nil },
  { name: "Dropbox", domain_name: "dropbox.com", category: "Software & Productivity", amount: 120, billing_cycle: "yearly", date_recurrence: Date.new(2025, 4, 24), status: "active", cancelled_at: nil },
  { name: "ChatGPT Plus", domain_name: "openai.com", category: "Software & Productivity", amount: 20, billing_cycle: "monthly", date_recurrence: Date.new(2025, 3, 18), status: "active", cancelled_at: nil },

  # Shopping & Retail
  { name: "Amazon Prime", domain_name: "amazon.com", category: "Shopping & Retail", amount: 15, billing_cycle: "monthly", date_recurrence: Date.new(2025, 1, 12), status: "active", cancelled_at: nil },
  { name: "Costco Membership", domain_name: "costco.com", category: "Shopping & Retail", amount: 5, billing_cycle: "monthly", date_recurrence: Date.new(2025, 2, 27), status: "active", cancelled_at: nil },
  { name: "Walmart Plus", domain_name: "walmart.com", category: "Shopping & Retail", amount: 98, billing_cycle: "yearly", date_recurrence: Date.new(2025, 6, 18), status: "active", cancelled_at: nil },
  { name: "Instacart Plus", domain_name: "instacart.com", category: "Shopping & Retail", amount: 99, billing_cycle: "yearly", date_recurrence: Date.new(2025, 4, 26), status: "cancelled", cancelled_at: Date.new(2026, 4, 26) },
]

subscriptions.each do |attrs|
  subscription = demo_user.subscriptions.find_or_initialize_by(name: attrs[:name])
  subscription.assign_attributes(
    amount: attrs[:amount],
    billing_cycle: attrs[:billing_cycle],
    category: category_records.fetch(attrs[:category]),
    date_recurrence: attrs[:date_recurrence],
    status: attrs[:status],
    cancelled_at: attrs[:cancelled_at],
    domain_name: attrs[:domain_name]
  )
  subscription.save!
end

puts "Subscriptions saved (#{subscriptions.length} total)"
