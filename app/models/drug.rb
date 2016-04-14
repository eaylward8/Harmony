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
  has_many :drug_interactions
  has_many :interactions, through: :drug_interactions

  validates :name, :rxcui, presence: true
  validates :rxcui, numericality: true

  # accepts_nested_attributes_for :prescriptions

  def self.all_drug_names
    self.pluck('name')
  end

  def interactions
    interactions = Interaction.joins(:drug_interactions).where("drug_id = ?", self.id)
    interactions.reject {|interaction| interaction.description == "No interactions."}
  end

  def associate_drug_names_with_interactions(interactions)
    interactions.map do |interaction|
      drug_interactions = DrugInteraction.all.select {|drug_interaction| drug_interaction.interaction_id == interaction.id}
      drug_interaction = drug_interactions.reject {|drug_interaction| drug_interaction.drug_id == self.id}
      drug = Drug.find(drug_interaction[0].drug_id)
      {drug_name: drug.name, interaction: interaction.description}
    end
  end

  def persist_interactions(user)
    drug_pairs = create_drug_pairs(user)
    interactions_not_known = drug_pairs.reject {|drug_pair| drug_interaction_is_known?(drug_pair)}
    interactions_not_known.each do |drug_pair|
      interaction = Adapters::InteractionClient.interactions(drug_pair)
      interaction.save
      DrugInteraction.create(drug_id: drug_pair[0].id, interaction_id: interaction.id)
      DrugInteraction.create(drug_id: drug_pair[1].id, interaction_id: interaction.id)
    end
  end

  # Returns an array of arrays pairing the drug passed in with all other active drugs
  def create_drug_pairs(user)
    drugs = user.active_drugs.reject {|d| d.name == self.name}
    drugs.map {|d| [self, d]}.uniq
  end

  # Checks whether both drugs passed in as arguments have already been recorded
  # in the drug interactions table and whether they share an interaction
  def drug_interaction_is_known?(drug_pair)
    DrugInteraction.find_by(drug_id: drug_pair[0].id) &&
    DrugInteraction.find_by(drug_id: drug_pair[1].id) &&
    DrugInteraction.find_by(drug_id: drug_pair[0].id).interaction_id ==
    DrugInteraction.find_by(drug_id: drug_pair[1].id).interaction_id
  end
end
