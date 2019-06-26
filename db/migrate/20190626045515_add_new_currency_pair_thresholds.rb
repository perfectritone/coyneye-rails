class AddNewCurrencyPairThresholds < ActiveRecord::Migration[5.2]
  def change
    create_table :currency_pairs do |t|
      t.bigint :to_currency_id
      t.bigint :from_currency_id
    end

    add_reference :maximum_thresholds, :currency_pair
    add_reference :minimum_thresholds, :currency_pair
  end
end
