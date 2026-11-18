module Ruddy
  class Record
    class << self
      def collection
        class_name = self.name.split('::').last.to_sym
        World.public_send(World::COLLECTIONS.fetch(class_name))
      end
      alias all collection

      def find(id)
        collection.fetch(id)
      end

      def where(attrs)
        collection.values.lazy.select do |record|
          catch :done do
            attrs.each do |name, value|
              record.public_send(name) == value or throw :done, false
            end

            true
          end
        end
      end
    end

    attr_reader :id

    def initialize(**attrs)
      attrs.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end
  end
end
