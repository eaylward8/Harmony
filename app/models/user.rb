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
      my_docs << "#{d.id} - Dr. #{d.first_name} #{d.last_name} - #{d.location}"
    end
    my_docs.uniq
  end

  def pharmacy_names
    my_pharms = []
    self.pharmacies.collect do |p|
      my_pharms << "#{p.id} - #{p.name} - #{p.location}"
    end
    my_pharms.uniq
  end

  def active_prescriptions
    self.prescriptions.where("end_date >= ?", Date.today).where("start_date <= ?", Date.today)
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

  def prescriptions_by_time_of_day(time_of_day)
    prescriptions = self.active_prescriptions.select do |prescription|
      prescription.scheduled_doses.map {|dose| dose.time_of_day}.include?(time_of_day)
    end
    render_prescriptions(prescriptions, time_of_day)
  end

  def render_prescriptions(prescriptions, time_of_day)
    prescriptions.map do |prescription|
      name = prescription.drug.name
      doses = prescription.scheduled_doses.select {|dose| dose.time_of_day == time_of_day}.count
      dose_size = prescription.dose_size
      {name: name, doses: doses, dose_size: dose_size}
    end
  end

  def active_drugs
    self.active_prescriptions.map do |prescription|
      prescription.drug.name
    end
  end

  def update_drug_interactions(drug)
    self.active_drugs.combination(2).to_a.select{|pair| pair.include?(drug.name)}.map do |pair|
      drug1 = Drug.find_by(name: pair.first)
      drug2 = Drug.find_by(name: pair.second)
      unless drug_interaction_is_known?(drug1, drug2)
        interaction = Adapters::InteractionClient.interactions(pair.first, pair.second)
        # Stopped here - should add Interaction & DrugInteraction to the database - remove mapping in line 92?
        binding.pry
      end
    end
  end

  def drug_interaction_is_known?(drug1, drug2)
    DrugInteraction.find_by(drug_id: drug1.id) &&
    DrugInteraction.find_by(drug_id: drug2.id) &&
    DrugInteraction.find_by(drug_id: drug1.id).interaction_id == DrugInteraction.find_by(drug_id: drug2.id).interaction_id
  end
end