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
end
