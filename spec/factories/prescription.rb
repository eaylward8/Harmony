FactoryGirl.define do

  factory :prescription do
    association :user
    association :drug
    association :doctor
    association :pharmacy

    dose_size { "#{rand(20..500)}mg" }
    refills { rand(1..5) }
    fill_duration { rand(1..20) }
    start_date { Date.today + rand(-30..30) }
    end_date { (start_date || Date.today) + (fill_duration || 6) }

    factory :no_refills_prescription do
      refills 0
      fill_duration 3
      start_date { Date.today }
    end

    factory :expiring_soon do
      fill_duration 3
      start_date { Date.today }
    end

    factory :active_prescription do
      start_date { Date.today }
    end

    factory :inactive_prescription do
      start_date { Date.today - rand(40..200)}
    end
  end
end