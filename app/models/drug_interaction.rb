# == Schema Information
#
# Table name: drug_interactions
#
#  id             :integer          not null, primary key
#  drug_id        :integer
#  interaction_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class DrugInteraction < ActiveRecord::Base
  include Adapters::InteractionApi
  belongs_to :drugs
  belongs_to :interactions


end
