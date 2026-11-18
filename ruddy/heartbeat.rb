require 'singleton'

module Ruddy
  class Heartbeat
    include Singleton

    attr_reader :thread

    def start
      @thread = Thread.start do
        Thread.current.abort_on_exception = true

        sleep
      end
    end
  end
end
