# == Schema Information
#
# Table name: pharmacies
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Pharmacy < ActiveRecord::Base
  has_many :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :drugs, through: :prescriptions

  validates :name, :location, presence: true
end
