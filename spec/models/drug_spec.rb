require 'rails_helper'

describe 'Drug' do

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:drug)).to be_valid
    end
  end

  describe 'validations' do

    it 'is invalid without a name' do
      drug = build(:drug, name: nil)
      drug.valid?

      expect(drug.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a RXCUI number' do
      drug = build(:drug, rxcui: nil)
      drug.valid?

      expect(drug.errors[:rxcui]).to include("can't be blank")
    end

    it 'is invalid if the RXCUI is not a number (Fixnum)' do
      drug = build(:drug)

      expect(drug.rxcui.class).to eq(Fixnum)
    end
  end

  describe 'scopes' do

    before(:each) do
      @drug = Drug.create(name: 'Lipitor', rxcui: '153165')
      Drug.create(name: 'Hydrocodone', rxcui: '5489')
      @interaction = Interaction.create(description: 'The serum concentration of Hydrocodone can be increased when it is combined with Atorvastatin.')
      DrugInteraction.create(drug_id: 1, interaction_id: 1)
      DrugInteraction.create(drug_id: 2, interaction_id: 1)
    end

    describe 'self.interacting_pair' do
      it 'returns a pair of interacting drugs' do
        expect(Drug.interacting_pair(@interaction).first.id).to eq(1)
        expect(Drug.interacting_pair(@interaction).second.id).to eq(2)
      end
    end

    describe 'self.interacting_drug' do
      it 'returns an interacting drug' do
        expect(Drug.interacting_drug(@interaction, @drug).first.id).to eq(2)
      end
    end
  end
end