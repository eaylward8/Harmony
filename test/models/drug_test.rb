# == Schema Information
#
# Table name: drugs
#
#  id         :integer          not null, primary key
#  name       :string
#  rxcui      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class DrugTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
