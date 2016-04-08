# == Schema Information
#
# Table name: doctors
#
#  id         :integer          not null, primary key
#  location   :string
#  specialty  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  first_name :string
#  last_name  :string
#

require 'test_helper'

class DoctorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
