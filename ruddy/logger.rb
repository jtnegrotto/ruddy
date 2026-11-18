require 'logger'
require 'singleton'
require 'delegate'

module Ruddy
  class Logger < SimpleDelegator
    include Singleton

    attr_reader :logger

    def initialize
      @logger = ::Logger.new($stdout)
      super(logger)
    end
  end
end
