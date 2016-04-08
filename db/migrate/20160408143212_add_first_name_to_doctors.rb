class AddFirstNameToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :first_name, :string
  end
end
