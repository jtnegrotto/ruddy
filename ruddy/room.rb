module Ruddy
  class Room < Record
    attr_accessor :name, :description
    
    def players
      Player.where(room_id: id)
    end
  end
end
