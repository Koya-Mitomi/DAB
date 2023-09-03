class AddUserIdToIncomeAmounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :income_amounts, :user, null: false, foreign_key: true
    add_reference :expenditure_amounts, :user, null: false, foreign_key: true
  end
end
