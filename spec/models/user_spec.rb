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

describe User do 
  
  context "Validations" do 

    let(:user) { User.new(first_name: "John", last_name: "Johnson", email: "john@yahoo.com", password: "password123")}
    
    it "requires first and last name, email, and password to be created" do
      expect(user).to be_valid
    end

    it "is invalid without a first name" do
      user.first_name = nil
      expect(user).to be_invalid
    end

    it "is invalid without a last name" do
      user.last_name = nil
      expect(user).to be_invalid
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).to be_invalid
    end

    it "is invalid without a password" do
      user.password = nil
      expect(user).to be_invalid
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

















