module Ruddy
  class Player < Record
    attr_accessor :name, :room_id

    def room
      Room.find(room_id)
    end
  end
end
