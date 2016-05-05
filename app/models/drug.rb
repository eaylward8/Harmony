class Drug < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :drug_interactions
  has_many :interactions, through: :drug_interactions

  validates :name, :rxcui, presence: true
  validates :rxcui, numericality: true

  scope :interacting_pair, -> (interaction) do
    joins(:drug_interactions).where('interaction_id = ?', interaction.id)
  end
  scope :interacting_drug, -> (interaction, drug) do
    joins(:drug_interactions).where('interaction_id = ? AND drug_id != ?', interaction.id, drug.id)
  end

  def self.valid?(drug_name)
    self.find_by_name(drug_name) ? true : !!Adapters::DrugClient.find_by_name(drug_name).rxcui
  end

  def interacting_drugs_and_descriptions(user)
    self.interactions.with_description.map do |interaction|
    { drug_name: Drug.interacting_drug(interaction, self).first.name,
      interaction: interaction.description }
    end.uniq.select do |interaction|
      user.active_drug_names.include?(interaction[:drug_name])
    end
  end

  def persist_interactions(user)
    self.pair_with_active_drugs(user).reject do |drug_pair|
      drugs_persisted?(drug_pair) && drug_interaction_persisted?(drug_pair)
    end.each do |drug_pair|
      interaction = Adapters::InteractionClient.interactions(drug_pair)
      interaction.save
      DrugInteraction.create(drug_id: drug_pair[0].id, interaction_id: interaction.id)
      DrugInteraction.create(drug_id: drug_pair[1].id, interaction_id: interaction.id)
    end
  end

  def pair_with_active_drugs(user)
    user.prescriptions.active.reject do |prescription|
      prescription.drug.name == self.name
    end.map { |prescription| [self, prescription.drug] }.uniq
  end

  def drugs_persisted?(drug_pair)
    DrugInteraction.where(drug_id: drug_pair[0].id).count > 0 &&
    DrugInteraction.where(drug_id: drug_pair[1].id).count > 0
  end

  def drug_interaction_ids(drug)
    DrugInteraction.where(drug_id: drug.id).pluck(:interaction_id)
  end

  def drug_interaction_persisted?(drug_pair)
    drug_1_interaction_ids = drug_interaction_ids(drug_pair[0])
    drug_2_interaction_ids = drug_interaction_ids(drug_pair[1])
    (drug_1_interaction_ids & drug_2_interaction_ids).count > 0
  end
end