class Interaction < ActiveRecord::Base
  has_many :drug_interactions
  has_many :drugs, through: :drug_interactions

  scope :drug, -> (drug) { joins(:drug_interactions).where('drug_id = ?', drug.id) }
  scope :with_description, -> { where('description != ?', 'No interactions.') }
end