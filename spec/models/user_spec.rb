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

  describe 'object relations' do 
    it 'can have many prescriptions' do 
      user = create(:user, :with_many_prescriptions)

      expect(user.prescriptions.count).to eq(3)
    end
  end


  describe "instance methods" do
    # create user with 2 prescriptions, doctors, drugs, & pharmacies
    let(:user1) { create(:user, :with_many_prescriptions, number_of_prescriptions: 2) }

    describe "#doctors_names" do

      it "returns a formatted list of all of a user's doctors" do
        d1 = user1.doctors.first
        d2 = user1.doctors.last

        expect(user1.doctors_names).to eq(["#{d1.id} - Dr. #{d1.first_name} #{d1.last_name} - #{d1.location}", "#{d2.id} - Dr. #{d2.first_name} #{d2.last_name} - #{d2.location}"])
      end

    end
  end
end

















