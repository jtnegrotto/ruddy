require "singleton"
require "socket"

module Ruddy
  class Server
    include Singleton

    attr_reader :thread, :mutex, :clients

    def start(host: "localhost", port: 9999)
      Ruddy.logger.info "Starting Ruddy server at #{host}:#{port}"

      @mutex = Mutex.new
      @clients = {}

      tcp_server = TCPServer.new(host, port)

      @thread = Thread.start do
        Thread.current.abort_on_exception = true

        loop do
          socket = tcp_server.accept
          client = Client.new(socket)
          mutex.synchronize { clients[client.id] = client }
          Ruddy.logger.info "Client connected #{client.id}"

          Thread.start(client) do |client|
            begin
              client.session.start
            ensure
              close(client)
            end
          end
        end
      end
    end

    def close(client)
      client.close unless client.closed?
      mutex.synchronize { clients.delete(client.id) }
      Ruddy.logger.info "Client disconnected #{client.id}"
    end
  end
end
