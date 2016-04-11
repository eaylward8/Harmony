class AddDoseSizeToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :dose_size, :string
  end
end
