class Pharmacy < ActiveRecord::Base
  has_many :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :drugs, through: :prescriptions

  validates :name,  presence: true
end