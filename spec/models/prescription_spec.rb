require 'rails_helper'

describe 'Prescription' do

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:prescription)).to be_valid
    end
  end

  describe 'validations' do

    it 'is invalid without a dose size' do
      rx = build(:prescription, dose_size: nil)
      rx.valid?

      expect(rx.errors[:dose_size]).to include("can't be blank")
    end

    it 'is invalid without a fill duration' do
      rx = build(:prescription, fill_duration: nil)
      rx.valid?

      expect(rx.errors[:fill_duration]).to include("can't be blank")
    end

    it 'is invalid without a number of refills' do
      rx = build(:prescription, refills: nil)
      rx.valid?

      expect(rx.errors[:refills]).to include("can't be blank")
    end

    it 'is invalid without a start date' do
      rx = build(:prescription, start_date: nil)
      rx.valid?

      expect(rx.errors[:start_date]).to include("can't be blank")
    end
  end

  describe 'scopes' do

    before(:each) do
      Prescription.create(refills: 1, fill_duration: 1, start_date: Date.today, end_date: Date.today + 7, dose_size: '100mg')
      Prescription.create(refills: 1, fill_duration: 1, start_date: Date.today - 30, end_date: Date.today - 29, dose_size: '100mg')
      Prescription.create(refills: 1, fill_duration: 1, start_date: Date.today, end_date: Date.today + 1, dose_size: '100mg')
      ScheduledDose.create(time_of_day: 'morning', prescription_id: 1)
    end

    describe 'self.active' do
      it 'returns active prescriptions' do
        expect(Prescription.active.length).to eq(2)
        expect(Prescription.active.first.id).to eq(1)
      end
    end

    describe 'self.inactive' do
      it 'returns inactive prescriptions' do
        expect(Prescription.inactive.length).to eq(1)
        expect(Prescription.inactive.first.id).to eq(2)
      end
    end

    describe 'self.ending_within_week' do
      it 'returns prescriptions ending within one week' do
        expect(Prescription.ending_within_week.length).to eq(1)
        expect(Prescription.ending_within_week.first.id).to eq(3)
      end
    end

    describe 'self.time_of_day' do
      it 'returns prescriptions by time of day' do
        expect(Prescription.time_of_day('morning').length).to eq(1)
        expect(Prescription.time_of_day('morning').first.id).to eq(1)
      end
    end
  end
end