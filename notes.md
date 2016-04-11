App functionality:

  - Let users see what drugs they're prescribed and by which doctors
  - Doctors can prescribe via the app to pharmacists
  - 



models


User
name  |     dob    |  
Doug    10/19/1977
Leon    09/28/1991
has_many prescriptions
has_many pharmacies, through: :prescription
has_many doctors, through: :prescription
has_many drugs, through: :prescription

Pharmacy
name | location
has_many prescriptions
has_many doctors, through: :prescription
has_many users, through: :prescription
has_many drugs, through: :prescription

Doctor 
name | location | specialty
has_many prescriptions
has_many pharmacies, through: :prescription
has_many users, through: :prescription
has_many drugs, through: :prescription

Drug 
name  | generic name | form | rxcui
has_many prescriptions
has_many pharmacies, through: :prescription
has_many users, through: :prescription
has_many doctors, through: :prescription

Prescription
dose_size | refills | fill duration | start date | end date | Doctor ID | Pharm ID | User ID | Drug  ID| 
  10mg        3         7             4/22/2016   4/29/2016   1          1         1          1
belongs_to drug
belongs_to doctor
belongs_to pharmacy
belongs_to user
has_many scheduled_doses

Scheduled_Doses
time_of_day | Prescription_ID | 
  morning           1          
  morning           1
  evening           1
belongs_to prescription




