class Prescription < ActiveRecord::Base
  belongs_to :drug
  belongs_to :doctor
  belongs_to :pharmacy
  belongs_to :user

  def drug_name_to_id(name)
    drug = Drug.find_by_name(name)
    self.drug_id = drug.id
  end
end
