# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_name      :string
#  last_name       :string
#  email           :string
#  password_digest :string
#

class User < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :drugs, through: :prescriptions

  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def upcoming_refills
    refills = Prescription.user(self).active.select do |p|
      p.end_date < (Date.today + 6)
    end
    refills.sort_by { |p| p.end_date }
  end

  def regimen(time_of_day)
    Prescription.user(self).active.time_of_day(time_of_day).map do |prescription|
      { name: prescription.drug.name,
        dose_size: prescription.dose_size,
        doses: prescription.doses_by_time_of_day(time_of_day),
        interactions: prescription.drug.interactions(self) }
    end
  end

  def drugs_actively_taking
    Prescription.user(self).active.map do |prescription|
      prescription.drug
    end
  end

end