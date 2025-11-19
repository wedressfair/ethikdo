require_relative 'base_model'

module Ethikdo
  class Provision < BaseModel
    attr_accessor :card_number
    attr_accessor :capture_token
    attr_accessor :card_value
    attr_accessor :date_created
    attr_accessor :date_used
    attr_accessor :url
    attr_accessor :status_code
    attr_accessor :error_code
    attr_accessor :message
    attr_accessor :count
    attr_accessor :next
    attr_accessor :previous
    attr_accessor :results

    def self.create(card_number:, card_crypto:)
      response = execute("post", '/provisions/', body: { card_number: card_number.to_s, card_crypto: card_crypto.to_s }.to_json)
      self.new(response.parsed_response)
    end

    def self.all
      response = execute('get', '/provisions/')
      self.new(response.parsed_response)
    end
  end
end
