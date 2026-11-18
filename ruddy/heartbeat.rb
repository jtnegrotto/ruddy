require 'singleton'

module Ruddy
  class Heartbeat
    include Singleton

    attr_reader :thread, :pulse

    PULSES_PER_SECOND = 4
    NUM_BUCKETS = 1024

    HeartbeatEvent = Data.define(:due_at, :callable)

    def initialize
      @pulse = 0
      @buckets = Array.new(NUM_BUCKETS) { [] }
      @incoming = Queue.new
    end

    def start
      @thread = Thread.start do
        Thread.current.abort_on_exception = true

        interval = 1.0 / PULSES_PER_SECOND

        loop do
          started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          beat!
          finished_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          sleep [interval - (finished_at - started_at), 0].max
        end
      end
    end

    def enqueue(pulses, callable)
      @incoming << [pulses, callable]
    end

    private

    def beat!
      Ruddy.logger.debug { "Heartbeat #{pulse}" }

      @incoming.size.times do
        pulses, callable = @incoming.pop
        target = pulses + pulse
        @buckets[target % NUM_BUCKETS] << HeartbeatEvent.new(target, callable)
      end

      bucket_idx = pulse % NUM_BUCKETS
      ready, pending = @buckets[bucket_idx].partition do |event|
        event.due_at <= pulse
      end
      @buckets[bucket_idx] = pending

      ready.each { |event| event.callable.call }

      @pulse += 1
    end
  end
end
