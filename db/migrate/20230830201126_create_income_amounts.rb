class CreateIncomeAmounts < ActiveRecord::Migration[7.0]
  def change
    create_table :income_amounts do |t|
      t.date :date
      t.integer :amount
      t.references :income, null: false, foreign_key: true

      t.timestamps
    end
  end
end
