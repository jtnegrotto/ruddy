require "forwardable"

module Ruddy
  class Client
    extend Forwardable

    attr_reader :socket, :id, :session

    def_delegators :@socket, :gets, :puts, :close, :closed?

    def initialize(socket)
      @socket = socket
      @id = socket.remote_address.ip_unpack * ':'
      @session = Session.new(self)
    end
  end
end
