class IncomeAmount < ApplicationRecord
  belongs_to :income
  belongs_to :user
  validates :user_id, presence: true
  validates :income_id, presence: true
  validates :amount, presence: true, numericality: { in: 0..1000000000000 }
  validates :date,   presence: true
end
