# == Schema Information
#
# Table name: prescriptions
#
#  id            :integer          not null, primary key
#  dosage        :string
#  doses         :integer
#  doses_per_day :integer
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
#

require 'test_helper'

class PrescriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
