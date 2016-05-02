class DrugInteraction < ActiveRecord::Base
  belongs_to :drug
  belongs_to :interaction
end