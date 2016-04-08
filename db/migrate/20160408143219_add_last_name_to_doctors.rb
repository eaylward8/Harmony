class AddLastNameToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :last_name, :string
  end
end
