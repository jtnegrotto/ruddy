module Ruddy
  class Session
    attr_reader :client, :flow, :name

    FLOWS = [
      SIGN_IN = :sign_in,
      PLAY = :play,
      DISCONNECTED = :disconnected,
    ]

    def initialize(client)
      @client = client
      @flow = SIGN_IN
    end

    def deconstruct_keys(_keys)
      {
        flow:,
      }
    end

    def start
      catch :disconnected do
        loop do
          case self
          in flow: SIGN_IN
            sign_in
          in flow: PLAY
            play
            @flow = DISCONNECTED
          in flow: DISCONNECTED
            disconnected
          else
            raise "Invalid state"
          end
        end
      end
    end

    def sign_in
      client.puts "What is your name?"
      input = client.gets&.strip
      
      if input.nil?
        @flow = DISCONNECTED
        return
      end

      if input.length.zero?
        client.puts "Come on, you have to have a name..."
      else
        @name = input
        @flow = PLAY
      end
    end

    def play
      client.puts "Welcome, #{name}."
    end

    def disconnected
      throw :disconnected
    end
  end
end
