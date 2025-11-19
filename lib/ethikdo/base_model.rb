require_relative 'error'
require 'httparty'

module Ethikdo
  class BaseModel
    def initialize(attributes = {})
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        send(m, value) if respond_to?(m)
      end
    end

    private

    BASE_TEST_URL = "https://recette.ethikdo.co/api/v1"
    BASE_URL = "https://www.ethikdo.co/api/v1"

    def self.api_key
      Ethikdo::configuration.api_key
    end

    def self.execute(method, path, options = {})
      begin
        response = request(method, path, options)
      rescue *Error::NET_HTTP_ERRORS => err
        raise ConnectionError.new, err.message
      end

      case response.code
      when 200..299
        response
      when 400
        raise BadRequestError.new(response)
      when 401
        raise AuthenticationError.new(response)
      when 404
        raise NotFoundError.new(response)
      when 400..499
        raise ResponseError.new(response)
      when 500
        raise InternalServerError.new(response)
      when 500..599
        raise ServerError.new(response)
      end
    end

    def self.request(method, path, options = {})
      HTTParty.send(method, base_url + path, base_options.merge(options))
    end

    def self.base_url
      Ethikdo::configuration.environment == :production ? BASE_URL : BASE_TEST_URL
    end

    def self.base_options
      {
        headers: {
          'Accept' => 'application/json',
          'Authorization' => api_key,
          'Content-Type' => 'application/json'
        }
      }
    end
  end
end
