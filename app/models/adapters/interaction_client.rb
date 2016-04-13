module Adapters
  class InteractionClient

    def self.connection
      @connection ||= Adapters::DrugInteractionsApiConnection.new
    end

    # Drug instance method; searches API by one or more drug names and returns array of interactions
    def self.interactions(drug_pair)
      rxcuis = drug_pair.map { |drug| Adapters::DrugClient.find_by_name(drug.name).rxcui }
      get_interactions(rxcuis)
    end

    # def self.get_interactions_for_med(rxcui)
    #   response = connection.class.get("/interaction/interaction.json?rxcui=#{rxcui}")
    #   interaction_pairs = response["interactionTypeGroup"][0]["interactionType"][0]["interactionPair"]
    #   interaction_pairs.map! do |pair|
    #     rxcui = pair["interactionConcept"][1]["minConceptItem"]["rxcui"]
    #     name = pair["interactionConcept"][1]["minConceptItem"]["name"]
    #     description = pair["description"]
    #     {name: name, rxcui: rxcui, description: description}
    #   end
    # end

    def self.get_interactions(rxcuis)
      interaction_description = ''
      rxcuis_list = rxcuis.join('+')
      response = connection.class.get("/interaction/list.json?rxcuis=#{rxcuis_list}")
      if response["fullInteractionTypeGroup"]
        interaction_pairs = response["fullInteractionTypeGroup"][0]["fullInteractionType"]
        interaction_pairs.map! do |pair|
          name_1 = pair["interactionPair"][0]["interactionConcept"][0]["minConceptItem"]["name"]
          name_2 = pair["interactionPair"][0]["interactionConcept"][1]["minConceptItem"]["name"]
          rxcui_1 = pair["interactionPair"][0]["interactionConcept"][0]["minConceptItem"]["rxcui"]
          rxcui_2 = pair["interactionPair"][0]["interactionConcept"][1]["minConceptItem"]["rxcui"]
          interaction_description = pair["interactionPair"][0]["description"]
        end
      else
        interaction_description = "No interactions."
      end
      Interaction.new(description: interaction_description)
    end
  end
end