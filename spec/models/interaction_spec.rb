require 'rails_helper'

describe 'Interaction' do

  describe 'scopes' do

    before(:each) do
      Interaction.create(description: 'The serum concentration of Hydrocodone can be increased when it is combined with Atorvastatin.')
      Interaction.create(description: 'No interactions.')
    end

    describe 'self.with_true_interactions' do
      it 'returns interactions with descriptions' do
        expect(Interaction.with_true_interactions.length).to eq(1)
      end
    end
  end
end