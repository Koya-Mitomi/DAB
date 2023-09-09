class ExpenditureAmount < ApplicationRecord
  belongs_to :expenditure
  belongs_to :user
  validates :user_id, presence: true
  validates :expenditure_id, presence: true
  validates :amount, presence: true, numericality: { in: 0..2000000000 }
  validates :date,   presence: true
end
