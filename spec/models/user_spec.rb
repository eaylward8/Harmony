# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_name      :string
#  last_name       :string
#  email           :string
#  password_digest :string
#
require 'rails_helper'

describe 'User' do

  describe 'factory' do 
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'validations' do

    it 'is invalid without a first name' do
      user = build(:user, first_name: nil)
      user.valid?

      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'is invalid without a last name' do
      user = build(:user, last_name: nil)
      user.valid?

      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'is invalid without an email address' do
      user = build(:user, email: nil)
      user.valid?

      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without a password' do
      user = build(:user, password: nil)
      user.valid?

      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  context "Instance methods" do

    let(:user) { User.create(first_name: "John", last_name: "Johnson", email: "john@yahoo.com", password: "password123")}

    let(:doctor) { Doctor.create(first_name: "Julius", last_name: "Erving", location: "Philadelphia") }

    let(:drug) { Drug.create(name: 'Ambien', rxcui: '131725') }

    let(:pharmacy) { Pharmacy.create(name: "CVS") }

    let(:prescription) { Prescription.create(refills: 2, fill_duration: 7, start_date: Date.today, end_date: Date.today + 7, doctor_id: doctor.id, pharmacy_id: pharmacy.id, user_id: user.id, drug_id: drug.id, dose_size: "100mg")}

    describe "#doctors_names" do

      it "returns a list of all of a user's doctors" do
        prescription.user = user
        prescription.doctor = doctor
        prescription.drug = drug
        prescription.pharmacy = pharmacy
        expect(user.doctors_names).to eq(["1 - Dr. Julius Erving - Philadelphia"])
      end

    end
  end
end

















