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

    # Drug instance method; searches API by one or more drug names and returns array of interactions
    def self.interactions(*drug_names)
      rxcuis = drug_names.map { |name| self.find_by_name(name).rxcui }
      if rxcuis.length == 1
        get_interactions_for_med(rxcuis.first)
      elsif rxcuis.length > 1
        get_interactions_for_meds(rxcuis)
      end
    end

    def self.get_interactions_for_med(rxcui)
      response = connection.class.get("/interaction/interaction.json?rxcui=#{rxcui}")
      interaction_pairs = response["interactionTypeGroup"][0]["interactionType"][0]["interactionPair"]
      interaction_pairs.map! do |pair|
        rxcui = pair["interactionConcept"][1]["minConceptItem"]["rxcui"]
        name = pair["interactionConcept"][1]["minConceptItem"]["name"]
        description = pair["description"]
        {name: name, rxcui: rxcui, description: description}
      end
    end

    def self.get_interactions_for_meds(rxcuis)
      rxcuis_list = rxcuis.join('+')
      response = connection.class.get("/interaction/list.json?rxcuis=#{rxcuis_list}")
      interaction_pairs = response["fullInteractionTypeGroup"][0]["fullInteractionType"]
      interaction_pairs.map! do |pair|
        name_1 = pair["interactionPair"][0]["interactionConcept"][0]["minConceptItem"]["name"]
        name_2 = pair["interactionPair"][0]["interactionConcept"][1]["minConceptItem"]["name"]
        rxcui_1 = pair["interactionPair"][0]["interactionConcept"][0]["minConceptItem"]["rxcui"]
        rxcui_2 = pair["interactionPair"][0]["interactionConcept"][1]["minConceptItem"]["rxcui"]
        description = pair["interactionPair"][0]["description"]
        {interaction_pairs: [{drug_1: {name: name_1, rxcui: rxcui_1}}, {drug_2: {name: name_2, rxcui: rxcui_2}}, description: description]}
      end
    end
  end
end