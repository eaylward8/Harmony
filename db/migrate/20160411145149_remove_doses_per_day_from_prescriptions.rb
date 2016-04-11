class RemoveDosesPerDayFromPrescriptions < ActiveRecord::Migration
  def change
    remove_column :prescriptions, :doses_per_day, :integer
  end
end
