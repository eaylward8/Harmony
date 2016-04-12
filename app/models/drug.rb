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
  include Adapters::InteractionApi
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :drug_interactions
  has_many :interactions, through: :drug_interactions

  validates :name, :rxcui, presence: true
  validates :rxcui, numericality: true

  # accepts_nested_attributes_for :prescriptions

  def self.all_drug_names
    self.pluck('name')
  end

end
