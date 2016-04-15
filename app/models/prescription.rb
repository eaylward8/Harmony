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

  def daily_schedule
    schedule = {morning: 0, afternoon: 0, evening: 0, bedtime: 0}
    self.scheduled_doses.each do |scheduled_dose|
      schedule[scheduled_dose.time_of_day.to_sym] += 1
    end
    schedule
  end

  def format_date(date)
    date.strftime('%A, %B %d')
  end


end
