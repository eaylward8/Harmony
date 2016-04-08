class RemoveNameFromDoctors < ActiveRecord::Migration
  def change
    remove_column :doctors, :name, :string
  end
end
