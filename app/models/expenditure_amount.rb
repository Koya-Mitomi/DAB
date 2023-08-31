class ExpenditureAmount < ApplicationRecord
  belongs_to :expenditure
  validates :expenditure_id, presence: true
  validates :amount, presence: true, length: { maximum: 50 }
  validates :date,   presence: true
end
