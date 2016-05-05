require 'rails_helper'

describe 'Pharmacy' do

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:pharmacy)).to be_valid
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      pharmacy = build(:pharmacy, name: nil)
      pharmacy.valid?
      expect(pharmacy.errors[:name]).to include("can't be blank")
    end
  end
end