class Expenditure < ApplicationRecord
  belongs_to :user
  has_many :expenditure_amounts, dependent: :destroy
  validates :user_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 },
                    uniqueness: { scope: :user }
end
