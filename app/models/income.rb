class Income < ApplicationRecord
  belongs_to :user
  has_many :income_amounts, dependent: :destroy
  validates :user_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 },
                    uniqueness: { scope: :user }
end
