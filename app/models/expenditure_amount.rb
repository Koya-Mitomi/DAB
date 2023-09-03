class ExpenditureAmount < ApplicationRecord
  belongs_to :expenditure
  belongs_to :user
  validates :expenditure_id, presence: true
  validates :amount, presence: true, length: { maximum: 50 }
  validates :date,   presence: true
end
