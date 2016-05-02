class Doctor < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :drugs, through: :prescriptions

  validates :first_name, :last_name, presence: true

  scope :user, -> (user) { joins(:prescriptions).where('user_id = ?', user.id).uniq }
end