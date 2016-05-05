FactoryGirl.define do

  factory :doctor do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    specialty {['Audiologist', 'Allergist', 'Anesthesiologist', 'Cardiologist', 'Dentist', 'Dermatologist'].sample}
    location {Faker::Address.street_address}
  end
end
