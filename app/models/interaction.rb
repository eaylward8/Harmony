# == Schema Information
#
# Table name: interactions
#
#  id          :integer          not null, primary key
#  description :string
#

class Interaction < ActiveRecord::Base
  has_many :drug_interactions
  has_many :drugs, through: :drug_interactions
end
