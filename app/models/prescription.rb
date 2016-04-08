# == Schema Information
#
# Table name: prescriptions
#
#  id            :integer          not null, primary key
#  dosage        :string
#  doses         :integer
#  doses_per_day :integer
#  refills       :integer
#  fill_duration :integer
#  start_date    :date
#  end_date      :date
#  doctor_id     :integer
#  pharmacy_id   :integer
#  user_id       :integer
#  drug_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Prescription < ActiveRecord::Base
  belongs_to :drug
  belongs_to :doctor
  belongs_to :pharmacy
  belongs_to :user

<<<<<<< HEAD
  validates :dosage, :doses, :doses_per_day, :refills, :fill_duration, :start_date, :end_date, presence: true
  validates :doses, :doses_per_day, :refills, :fill_duration, numericality: true 
=======
  def drug_name_to_id(name)
    drug = Drug.find_by_name(name)
    self.drug_id = drug.id
  end
>>>>>>> 29d9077e8050877e6835d8252694fb8e04bf50fb
end
