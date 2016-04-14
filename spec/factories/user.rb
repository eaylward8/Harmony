FactoryGirl.define do
  
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'password123'

    trait :with_many_prescriptions do 

      transient do 
        number_of_prescriptions 3
      end

      after(:create) do |user, evaluator|
        create_list(:prescription, evaluator.number_of_prescriptions, user: user)
      end
    end


  end
end