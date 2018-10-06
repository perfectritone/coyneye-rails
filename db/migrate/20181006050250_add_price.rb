class AddPrice < ActiveRecord::Migration[5.2]
  def change
    create_table :prices do |t|
      t.integer :from_currency_id
      t.integer :to_currency_id
      t.float :amount

      t.timestamps
    end
  end
end
