class AddThresholdTable < ActiveRecord::Migration[5.2]
  def change
    create_table :maximum_thresholds do |t|
      t.float :amount
      t.boolean :met, default: false

      t.timestamps
    end

    create_table :minimum_thresholds do |t|
      t.float :amount
      t.boolean :met, default: false

      t.timestamps
    end
  end
end
