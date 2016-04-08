class RemoveGenericNameFromDrugs < ActiveRecord::Migration
  def change
    remove_column :drugs, :generic_name, :string
  end
end
