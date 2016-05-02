class Drug < ActiveRecord::Base
  has_many :prescriptions
  has_many :pharmacies, through: :prescriptions
  has_many :users, through: :prescriptions
  has_many :doctors, through: :prescriptions
  has_many :drug_interactions
  has_many :interactions, through: :drug_interactions

  validates :name, :rxcui, presence: true
  validates :rxcui, numericality: true

  scope :user_active_drugs, -> (user) do
    joins(:prescriptions).merge(Prescription.user(user).active)
  end
  scope :interacting_pair, -> (interaction) do
    joins(:drug_interactions).where('interaction_id = ?', interaction.id)
  end
  scope :interacting_drug, -> (interaction, drug) do
    joins(:drug_interactions).where('interaction_id = ? AND drug_id != ?', interaction.id, drug.id)
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
      Drug.user_active_drugs(user).pluck('name').include?(interaction[:drug_name])
    end.uniq
  end

  def interacting_drugs_and_descriptions(user)
    Interaction.drug(self).with_description.map do |interaction|
    { drug_name: Drug.interacting_drug(interaction, self).first.name,
      interaction: interaction.description }
    end
  end

  def persist_interactions(user)
    create_active_drug_pairs(user).reject do |drug_pair|
      drugs_persisted?(drug_pair) && drug_interaction_persisted?(drug_pair)
    end.each do |drug_pair|
      interaction = Adapters::InteractionClient.interactions(drug_pair)
      interaction.save
      DrugInteraction.create(drug_id: drug_pair[0].id, interaction_id: interaction.id)
      DrugInteraction.create(drug_id: drug_pair[1].id, interaction_id: interaction.id)
    end
  end

  def create_active_drug_pairs(user)
    Drug.user_active_drugs(user).reject do |drug|
      drug.name == self.name
    end.map { |drug| [self, drug] }.uniq
  end

  def drugs_persisted?(drug_pair)
    DrugInteraction.where(drug_id: drug_pair[0].id).count > 0 &&
    DrugInteraction.where(drug_id: drug_pair[1].id).count > 0
  end

  def drug_interaction_ids(drug)
    DrugInteraction.where(drug_id: drug.id).map do |drug_interaction|
      drug_interaction.interaction_id
    end
  end

  def drug_interaction_persisted?(drug_pair)
    drug_1_interaction_ids = drug_interaction_ids(drug_pair[0])
    drug_2_interaction_ids = drug_interaction_ids(drug_pair[1])
    (drug_1_interaction_ids & drug_2_interaction_ids).count > 0
  end
end