class Drug < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :doctors, through: :prescriptions
end
