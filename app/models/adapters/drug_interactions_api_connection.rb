module Adapters
  class DrugInteractionsApiConnection
    include HTTParty
    attr_reader :connection
    base_uri 'https://rxnav.nlm.nih.gov/REST'
    # Drug instance method; searches API by drug name and returns a new Drug object

    def initialize
      @connection = self.class
    end
  end
end