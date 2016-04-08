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

  validates :dosage, :doses, :doses_per_day, :refills, :fill_duration, :start_date, :end_date, presence: true
  validates :doses, :doses_per_day, :refills, :fill_duration, numericality: true 


end
