class RemoveDosesFromPrescriptions < ActiveRecord::Migration
  def change
    remove_column :prescriptions, :doses, :integer
  end
end
