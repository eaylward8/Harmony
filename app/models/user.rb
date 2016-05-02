class User < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :drugs, through: :prescriptions

  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def regimen(time_of_day)
    Prescription.user(self).active.time_of_day(time_of_day).map do |prescription|
      { name: prescription.drug.name,
        dose_size: prescription.dose_size,
        doses: prescription.doses_by_time_of_day(time_of_day),
        interactions: prescription.drug.interactions(self) }
    end
  end
end