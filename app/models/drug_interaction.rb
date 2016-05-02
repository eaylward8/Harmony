class DrugInteraction < ActiveRecord::Base
  belongs_to :drugs
  belongs_to :interactions
end