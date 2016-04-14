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
    end_date { (start_date || Date.today) + (fill_duration || 7) }

  end
end

