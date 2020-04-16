require 'ethikdo/configuration'
require 'ethikdo/provision'
require 'ethikdo/transaction'
require 'ethikdo/version'

module Ethikdo
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
