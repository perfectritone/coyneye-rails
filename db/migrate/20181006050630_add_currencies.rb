class AddCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string :symbol

      t.timestamps
    end

    add_index :currencies, :symbol
  end
end
