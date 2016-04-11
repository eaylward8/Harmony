class RemoveDosageFromPrescriptions < ActiveRecord::Migration
  def change
    remove_column :prescriptions, :dosage, :string
  end
end
