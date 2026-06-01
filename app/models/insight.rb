class Insight < ApplicationRecord
  belongs_to :category
  belongs_to :subscription
  belongs_to :user
end
