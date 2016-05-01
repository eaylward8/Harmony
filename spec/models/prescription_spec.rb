
# == Schema Information
#
# Table name: prescriptions
#
#  id            :integer          not null, primary key
#  refills       :integer
#  fill_duration :integer
#  start_date    :date
#  end_date      :date
#  doctor_id     :integer
#  pharmacy_id   :integer
#  user_id       :integer
#  drug_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  dose_size     :string
#

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

end