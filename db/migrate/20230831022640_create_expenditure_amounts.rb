class CreateExpenditureAmounts < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditure_amounts do |t|
      t.date :date
      t.integer :amount
      t.references :expenditure, null: false, foreign_key: true

      t.timestamps
    end
  end
end
