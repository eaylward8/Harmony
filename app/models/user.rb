class User < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :drugs, through: :prescriptions

  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def regimen(time_of_day)
    self.prescriptions.active.time_of_day(time_of_day).map do |prescription|
      { name: prescription.drug.name,
        dose_size: prescription.dose_size,
        doses: prescription.doses_by_time_of_day(time_of_day),
        interactions: prescription.drug.interaction_data.select do |interaction|
          self.active_drug_names.include?(interaction[:drug_name])
        end }
    end
  end

  def active_drug_names
    self.prescriptions.active.joins(:drug).pluck(:name)
  end
end