class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.string :name
      t.string :generic_name
      t.stringrxcui :form

      t.timestamps null: false
    end
  end
end
