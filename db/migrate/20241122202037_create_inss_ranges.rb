class CreateInssRanges < ActiveRecord::Migration[7.2]
  def change
    create_table :inss_ranges do |t|
      t.decimal :lower_limit
      t.decimal :upper_limit
      t.decimal :rate

      t.timestamps
    end
  end
end
