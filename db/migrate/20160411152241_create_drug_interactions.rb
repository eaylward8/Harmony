class CreateDrugInteractions < ActiveRecord::Migration
  def change
    create_table :drug_interactions do |t|
      t.integer :drug_id
      t.integer :interaction_id

      t.timestamps null: false
    end

    create_table :interactions do |t|
      t.string :description
    end
  end
end
