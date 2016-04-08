class RemoveFormFromDrugs < ActiveRecord::Migration
  def change
    remove_column :drugs, :form, :string
  end
end
