require 'singleton'
require 'forwardable'

module Ruddy
  class World
    include Singleton

    COLLECTIONS = {
      Player: :players,
      Room: :rooms,
    }

    class << self
      extend Forwardable

      def_delegators :instance, *COLLECTIONS.values
    end

    attr_reader *COLLECTIONS.values

    def initialize
      COLLECTIONS.values.each do |collection|
        instance_variable_set("@#{collection}", {})
      end

      @rooms[1] = Room.new(
        id: 1,
        name: 'Test Room',
        description: 'A completely boring, nondescript room.'
      )
    end
  end
end
