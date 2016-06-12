class Interaction < ActiveRecord::Base
  has_many :drug_interactions
  has_many :drugs, through: :drug_interactions

  scope :with_true_interactions, -> { where('description != ?', 'No interactions.') }
end