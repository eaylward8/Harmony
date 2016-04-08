class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.string :name
      t.string :generic_name
      t.integer :rxcui
      t.string :form

      t.timestamps null: false
    end
  end
end
