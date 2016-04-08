# == Schema Information
#
# Table name: drugs
#
#  id         :integer          not null, primary key
#  name       :string
#  rxcui      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Drug < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :doctors, through: :prescriptions
<<<<<<< HEAD

  validates :name, :rxcui, presence: true
  validates :rxcui, numericality: true
=======
  # accepts_nested_attributes_for :prescriptions
>>>>>>> 29d9077e8050877e6835d8252694fb8e04bf50fb
end
