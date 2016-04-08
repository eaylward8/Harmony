# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

dr_leon = Doctor.create(first_name: 'Leon', last_name: 'Harary', location: 'Upper West Side', specialty: 'Proctologist')
dr_greg = Doctor.create(first_name: 'Greg', last_name: 'Marquet', location: 'Harlem', specialty: 'Brain Surgeon')
dr_erik = Doctor.create(first_name: 'Erik', last_name: 'Aylward', location: 'Brooklyn', specialty: 'Pediatrician')
dr_doug = Doctor.create(first_name: 'Doug', last_name: 'Tebay', location: 'Brooklyn', specialty: 'Cardiologist')

flunisolide = Drug.create(name: 'Flunisolide', rxcui: '25120')
xanax = Drug.create(name: 'Xanax', rxcui: '202363')
viagra = Drug.create(name: 'Viagra', rxcui: '190465')
fluconazole = Drug.create(name: 'Fluconazole', rxcui: '207106')

duane_reade = Pharmacy.create(name: 'Duane Reade', location: '11 Broadway')
cvs = Pharmacy.create(name: 'CVS', location: '20 Park Avenue')

script1 = Prescription.create(dosage: '10mg', doses: 5, doses_per_day: 1, refills: 0, fill_duration: 5, start_date: '01-01-2016', end_date: '01-06-2016', doctor_id: 1, pharmacy_id: 1, user_id: 4, drug_id: 2)
script2 = Prescription.create(dosage: '5g', doses: 21, doses_per_day: 3, refills: 4, fill_duration: 7, start_date: '03-20-2016', end_date: '03-27-2016', doctor_id: 2, pharmacy_id: 1, user_id: 3, drug_id: 4)
script3 = Prescription.create(dosage: '20oz', doses: 100, doses_per_day: 25, refills: 2, fill_duration: 4, start_date: '02-05-2016', end_date: '02-09-2016', doctor_id: 3, pharmacy_id: 2, user_id: 2, drug_id: 3)
script4 = Prescription.create(dosage: '500mg', doses: 16, doses_per_day: 2, refills: 1, fill_duration: 8, start_date: '04-01-2016', end_date: '04-09-2016', doctor_id: 4, pharmacy_id: 2, user_id: 1, drug_id: 1)

jeffrey = User.create(first_name: 'Jeffrey', last_name: 'Katz')
sammy = User.create(first_name: 'Sammy', last_name: 'Mernick')
nami = User.create(first_name: 'Nami', last_name: 'Nami')
shirley = User.create(first_name: 'Shirley', last_name: 'Berry')