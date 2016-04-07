class CreatePharmacies < ActiveRecord::Migration
  def change
    create_table :pharmacies do |t|
      t.string :name
      t.string :location
      t.string :string

      t.timestamps null: false
    end
  end
end
