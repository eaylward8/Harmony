# == Schema Information
#
# Table name: pharmacies
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

  # context 'Validations' do

  #   let(:pharmacy) { build :pharmacy, name: 'CVS' }

  #   it "is valid" do
  #     # pharmacy = Pharmacy.create(name: "Erik", location: "New York")
  #     binding.pry
  #     expect(pharmacy).to be_valid
  #   end

    # it "is invalid with no name" do
    #   pharmacy = Pharmacy.new(phone_number: 5553054425)
    #   expect(pharmacy).to be_invalid
    # end

    # it "is invalid with a short number" do
    #   pharmacy = Pharmacy.new(name: "Caligula", phone_number: 555305442)
    #   expect(pharmacy).to be_invalid
    # end

    # it "is invalid when non-unique" do
    #   Pharmacy.create(name: "Caligula", phone_number: 5553054425)
    #   pharmacy = Pharmacy.new(name: "Caligula", phone_number: 5557890001)
    #   expect(pharmacy).to be_invalid
    # end

  # end

end
