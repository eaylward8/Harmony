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

  scope :user, -> (user) { joins(:prescriptions).where('user_id = ?', user.id) }
  scope :interacting_pair, -> (interaction) do
    joins(:drug_interactions).where('interaction_id = ?', interaction.id)
  end
  scope :interacting_drug, -> (interaction, drug) do
    joins(:drug_interactions).where('interaction_id = ? AND drug_id != ?', interaction.id, drug.id)
  end

  def self.all_drug_names
    self.pluck('name')
  end

  def self.is_valid_drug?(drug_name)
    return true if Drug.find_by_name(drug_name)
    if !Drug.find_by_name(drug_name)
      new_drug = Adapters::DrugClient.find_by_name(drug_name)
      !!new_drug.rxcui
    end
  end

  def interactions(user)
    interacting_drugs_and_descriptions(user).select do |interaction|
      user.drugs_actively_taking.map { |drug| drug.name }.include?(interaction[:drug_name])
    end.uniq
  end

  def interacting_drugs_and_descriptions(user)
    Interaction.drug(self).with_description.map do |interaction|
    { drug_name: Drug.interacting_drug(interaction, self).first.name,
      interaction: interaction.description }
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
    drugs = user.drugs_actively_taking.reject {|d| d.name == self.name}
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