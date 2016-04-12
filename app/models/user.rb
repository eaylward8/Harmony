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
  validates :first_name, :last_name, presence: true
  
  def doctors_names
    my_docs = []
    self.doctors.collect do |d|
      my_docs << "#{d.id} - Dr. #{d.first_name} #{d.last_name}"
    end
    my_docs
  end

  def active_prescriptions
    self.prescriptions.where("end_date >= ?", Date.today)
  end

  def inactive_prescriptions
    self.prescriptions.where("end_date < ?", Date.today)
  end

  def active_prescriptions_day(date)
    # return an array of day's active prescription objects
     self.prescriptions.where("end_date >= ?", date)
  end

  def prescription_schedule_week
    # [{4/8/2016: [script 1, script2]},{4/9/2016: [script 1, script2]}...] 
    today = Date.today
    schedule = []
    7.times do |i|
      schedule<< {(today + i) => active_prescriptions_day(today+i)}
    end
    schedule
  end

  def upcoming_refills
    # {script: refill date}
    # 7 days
    active_prescriptions.select do |p|
      (p.end_date < Date.today + 7) && (p.refills > 0 )
    end
  end

  def drugs_by_time_of_day(time_of_day)
    drugs = self.drugs.select do |drug|
      drug.prescriptions.joins(:scheduled_doses).where('time_of_day == ?', time_of_day).length > 0
    end
    drug_names_and_doses(drugs)
  end

  def drug_names_and_doses(drugs)
    drugs.map do |drug|
      count = drugs.select {|d| d.name == drug.name}.count
      {name: drug.name, count: count}
    end
  end
end
