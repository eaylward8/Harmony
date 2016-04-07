class CreatePrescriptions < ActiveRecord::Migration
  def change
    create_table :prescriptions do |t|
      t.string :dosage
      t.integer :doses
      t.integer :doses_per_day
      t.integer :refills
      t.integer :fill_duration
      t.date :start_date
      t.date :end_date
      t.integer :doctor_id
      t.integer :pharmacy_id
      t.integer :user_id
      t.integer :drug_id

      t.timestamps null: false
    end
  end
end
