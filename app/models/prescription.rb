# == Schema Information
#
# Table name: prescriptions
#
#  id            :integer          not null, primary key
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
#  dose_size     :string
#

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
  has_many :scheduled_doses

  validates :dose_size, :refills, :fill_duration, :start_date, presence: true
  validates :refills, :fill_duration, numericality: true 
# removed end date from validation

  def refill
    if refills > 0
      self.refills -= 1
      self.end_date += self.fill_duration
      self.save
    end
  end

  def calculate_doses
    self.doses = self.fill_duration/self.doses_per_day
    self.save
  end

  def calculate_end_date
    self.end_date = self.start_date + self.fill_duration    
    self.save
  end




end
