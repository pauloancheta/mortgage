class CreateInterestRates < ActiveRecord::Migration[5.2]
  def change
    create_table :interest_rates do |t|
      t.float :rate, null: false

      t.timestamps
    end

    InterestRate.create!(rate: 2.5)
  end
end
