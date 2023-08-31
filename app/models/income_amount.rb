class IncomeAmount < ApplicationRecord
  belongs_to :income
  validates :income_id, presence: true
  validates :amount, presence: true, length: { maximum: 50 }
  validates :date,   presence: true
end
