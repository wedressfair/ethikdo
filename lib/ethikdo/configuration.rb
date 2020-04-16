module Ethikdo
  class Configuration
    attr_accessor :api_key
    attr_reader :environment

    def initialize
      @api_key = nil
      @environment = :production
    end

    def environment=(env)
      env = env.to_sym
      @environment = [:production, :development].include?(env)? env : nil
    end
  end
end
