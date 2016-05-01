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
    refills = Prescription.user(self.id).active.select do |p|
      p.end_date < (Date.today + 6)
    end
    refills.sort_by { |p| p.end_date }
  end

  def prescriptions_by_time_of_day(time_of_day)
    prescriptions = Prescription.user(self.id).active.select do |prescription|
      prescription.scheduled_doses.map {|dose| dose.time_of_day}.include?(time_of_day)
    end
    render_prescriptions(prescriptions, time_of_day)
  end

  def render_prescriptions(prescriptions, time_of_day)
    prescriptions.map do |prescription|
      name = prescription.drug.name
      doses = prescription.scheduled_doses.select {|dose| dose.time_of_day == time_of_day}.count
      dose_size = prescription.dose_size
      interactions = prescription.drug.interactions
      interactions = prescription.drug.associate_drug_names_with_interactions(interactions)
      interactions = self.active_drugs_interactions(interactions)
      {name: name, doses: doses, dose_size: dose_size, interactions: interactions}
    end
  end

  def active_drugs
    Prescription.user(self.id).active.map do |prescription|
      prescription.drug
    end
  end

  def active_drugs_interactions(interactions)
    interactions.select do |interaction|
      self.active_drugs.map {|drug| drug.name}.include?(interaction[:drug_name])
    end
  end
end