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

  describe 'instance methods' do
    before(:each) do
      @user = User.create(first_name: 'John', last_name: 'Doe', email: 'johndoe@gmail.com', password: 'password')
      Drug.create(name: 'Lipitor', rxcui: '153165')
      Drug.create(name: 'Hydrocodone', rxcui: '5489')
      Prescription.create(refills: 1, fill_duration: 1, start_date: Date.today, end_date: Date.today + 1, dose_size: '100mg', user_id: 1, drug_id: 1)
      Prescription.create(refills: 1, fill_duration: 1, start_date: Date.today, end_date: Date.today + 1, dose_size: '100mg', user_id: 1, drug_id: 2)
      ScheduledDose.create(time_of_day: 'morning', prescription_id: 1)
      ScheduledDose.create(time_of_day: 'morning', prescription_id: 2)
      Interaction.create(description: 'The serum concentration of Hydrocodone can be increased when it is combined with Atorvastatin.')
      DrugInteraction.create(drug_id: 1, interaction_id: 1)
      DrugInteraction.create(drug_id: 2, interaction_id: 1)
    end

    describe '#regimen' do
      it 'returns info about drugs the user is taking at a given time of day' do
        expect(@user.regimen('morning').first[:name]).to eq('Lipitor')
        expect(@user.regimen('morning').first[:dose_size]).to eq('100mg')
        expect(@user.regimen('morning').first[:doses]).to eq(1)
        expect(@user.regimen('morning').first[:interactions].first[:drug_name]).to eq('Hydrocodone')
        expect(@user.regimen('morning').first[:interactions].first[:interaction]).to eq('The serum concentration of Hydrocodone can be increased when it is combined with Atorvastatin.')
      end
    end

    describe '#active_drug_names' do
      it 'returns the names of drugs the user is actively taking' do
        expect(@user.active_drug_names).to eq(['Lipitor', 'Hydrocodone'])
      end
    end
  end
end