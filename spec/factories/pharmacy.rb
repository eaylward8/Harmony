FactoryGirl.define do

  factory :pharmacy do
    name {Faker::Company.name}
    location {Faker::Address.street_address}
  end
end
