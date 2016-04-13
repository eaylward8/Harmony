FactoryGirl.define do 

  factory :prescription do 
    dose_size { "#{rand(20..500)}mg" }
    refills { rand(1..5) }
    fill_duration { rand(1..20) }
    start_date { Date.today + rand(-30..30) }
    end_date { (start_date || Date.today) + (fill_duration || 7) }
  end

end

# validates :dose_size, :refills, :fill_duration, :start_date, presence: true
# validates :refills, :fill_duration, numericality: true