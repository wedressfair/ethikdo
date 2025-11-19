require_relative 'base_model'

module Ethikdo
  class Transaction < BaseModel
    attr_accessor :url
    attr_accessor :transaction_id
    attr_accessor :card_number
    attr_accessor :amount_purchased
    attr_accessor :amount_debited
    attr_accessor :cancelled
    attr_accessor :date
    attr_accessor :refund_amount
    attr_accessor :message
    attr_accessor :count
    attr_accessor :next
    attr_accessor :previous
    attr_accessor :results
    attr_accessor :customer_email

    def self.create(capture_token:, amount_requested:, amount_purchased: 0, transaction_id:, customer_email: nil)
      response = execute('post', '/sales/', body: {
        capture_token: capture_token,
        amount_requested: amount_requested.to_s,
        amount_purchased: amount_purchased.to_s,
        transaction_id: transaction_id.to_s,
        customer_email: customer_email
      }.to_json)
      self.new(response.parsed_response)
    end

    def self.cancel(transaction_id:)
      response = execute('get', "/sales/#{transaction_id}/cancel")
      self.new(response.parsed_response)
    end

    def self.all
      response = execute('get', '/sales/')
      self.new(response.parsed_response)
    end
  end
end
