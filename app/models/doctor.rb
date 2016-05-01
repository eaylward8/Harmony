# == Schema Information
#
# Table name: doctors
#
#  id         :integer          not null, primary key
#  location   :string
#  specialty  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  first_name :string
#  last_name  :string
#

class Doctor < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :drugs, through: :prescriptions

  validates :first_name, :last_name, presence: true

  scope :user, -> (id) { joins(:prescriptions).where('user_id = ?', id).uniq }

  def self.format_names(user)
    Doctor.user(user.id).collect do |doctor|
      "#{doctor.id} - Dr. #{doctor.first_name} #{doctor.last_name} - #{doctor.location}"
    end
  end

  def professional_name
    "Dr. #{self.first_name} #{self.last_name}"
  end

end