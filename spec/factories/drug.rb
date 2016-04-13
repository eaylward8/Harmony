FactoryGirl.define do

  factory :drug do 
    drugs = [{name: 'Lipitor', rxcui: '153165'}, {name: 'Hydrocodone', rxcui: '5489'}, {name: 'Prinivil', rxcui: '203644'}, {name: 'Tenormin', rxcui: '152413'}, {name: 'Viagra', rxcui: '190465'}]

    drug = drugs.sample

    name { drug[:name] }
    rxcui { drug[:rxcui] }
  end
end