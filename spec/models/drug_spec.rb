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

end








