module Adapters
  class DrugInteractionsApiConnection
    include HTTParty
    attr_reader :connection
    base_uri 'https://rxnav.nlm.nih.gov/REST'

    def initialize
      @connection = self.class
    end
  end
end