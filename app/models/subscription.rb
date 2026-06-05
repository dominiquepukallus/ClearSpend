class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :shared_subscriptions, dependent: :destroy
  has_many :insights, dependent: :destroy

  validates :name, :date_recurrence, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :billing_cycle, presence: true, inclusion: { in: %w[weekly monthly yearly] }
  validates :status, presence: true, inclusion: { in: %w[active cancelled paused] }

  # app/models/subscription.rb

  def billing_dates_up_to(end_date = Date.current)
    return [] if date_recurrence.nil?

    interval = case billing_cycle
               when "monthly" then 1.month
               when "yearly"  then 1.year
               when "weekly"  then 1.week
               end

    dates = []
    current = date_recurrence
    while current <= end_date
      dates << current
      current = current.advance(if interval == 1.month
                                  { months: 1 }
                                else
                                  interval == 1.year ? { years: 1 } : { weeks: 1 }
                                end)
    end
    dates
  end

  def next_billing_date
    return nil if status == "cancelled"

    billing_dates_up_to(Date.current + 2.years).find { |d| d >= Date.current }
  end

  # app/models/subscription.rb

  def billing_date_in(month)
    return nil if status == "cancelled" && cancelled_at < month.beginning_of_month

    start = month.beginning_of_month
    finish = month.end_of_month
    current = date_recurrence

    step = case billing_cycle
           when "monthly" then { months: 1 }
           when "yearly"  then { years: 1 }
           when "weekly"  then { weeks: 1 }
           end

    while current <= finish
      return current if current >= start

      current = current.advance(step)
    end

    nil
  end
end
