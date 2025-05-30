# frozen_string_literal: true

module Jobs
  class InsertProduct
    @queue = {}
    @statuses = {}

    def self.enqueue(id, &block)
      @statuses[id] = :queued
      puts "Job #{id} has been enqueued."
      Thread.new do
        sleep 35 # Simulate product insertion delay
        block.call if block_given?
        @statuses[id] = :completed
        puts "Job #{id} has been completed."
      end
    end

    class << self
      attr_reader :statuses
    end
  end
end
