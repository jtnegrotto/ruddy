require_relative "ruddy/logger"
require_relative "ruddy/server"
require_relative "ruddy/client"
require_relative "ruddy/session"
require_relative "ruddy/heartbeat"

module Ruddy
  def self.start
    [
      server.start,
      heartbeat.start,
    ].each(&:join)
  end

  def self.logger
    Logger.instance
  end

  def self.server
    Server.instance
  end

  def self.heartbeat
    Heartbeat.instance
  end
end

Ruddy.start
