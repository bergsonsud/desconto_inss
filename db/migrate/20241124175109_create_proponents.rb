class CreateProponents < ActiveRecord::Migration[7.2]
  def change
    create_table :proponents do |t|
      t.string :name
      t.string :cpf
      t.date :birth_date
      t.decimal :salary
      t.decimal :discount
      t.string :personal_phone
      t.string :reference_phone
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
