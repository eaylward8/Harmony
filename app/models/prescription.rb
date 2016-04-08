class Prescription < ActiveRecord::Base
  belongs_to :drug
  belongs_to :doctor
  belongs_to :pharmacy
  belongs_to :user
end
