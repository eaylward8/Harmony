module Adapters
  class DrugClient

    def self.connection
      @connection ||= Adapters::DrugInteractionsApiConnection.new
    end

    def self.find_by_name(drug_name)
      response = connection.class.get("/rxcui?name=#{drug_name}")
      name = response['rxnormdata']['idGroup']['name'].capitalize
      rxcui = response['rxnormdata']['idGroup']['rxnormId']
      Drug.new(name: name, rxcui: rxcui)
    end
  end
end