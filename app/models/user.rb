# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  first_name :string
#  last_name  :string
#

class User < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :drugs, through: :prescriptions

  validates :first_name, :last_name, presence: true
  
  # def date_of_birth=(date)
  #   binding.pry
  # end
end
