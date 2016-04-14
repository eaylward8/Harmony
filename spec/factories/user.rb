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

    trait :with_an_active_and_inactive_prescription do 
      after(:create) do |user|
        create(:active_prescription, user: user)
        create(:inactive_prescription, user: user)
      end
    end

    trait :with_active_prescriptions do 
      transient do 
        number_of_prescriptions 3
      end

      after(:create) do |user, evaluator|
        create_list(:active_prescription, evaluator.number_of_prescriptions, user: user)
      end
    end 

    trait :has_prescriptions_with_and_wo_refills do
      after(:create) do |user|
        create(:no_refills_prescription, user: user)
        create(:expiring_soon, user: user)
      end
    end

  end
end