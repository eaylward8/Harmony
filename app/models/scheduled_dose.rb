# == Schema Information
#
# Table name: scheduled_doses
#
#  id              :integer          not null, primary key
#  time_of_day     :string
#  prescription_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ScheduledDose < ActiveRecord::Base
  belongs_to :prescription
end
