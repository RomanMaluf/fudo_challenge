# frozen_string_literal: true

module Jobs
  class InsertProduct
    @statuses = {}

    class << self
      attr_reader :statuses

      def enqueue(id, product)
        @statuses[id] = :queued
        puts "Job #{id} has been enqueued."
        Thread.new do
          sleep(5) unless ENV['RACK_ENV'] == 'test' # Simulate product insertion delay

          insert_product(id, product)
          @statuses[id] = :completed
          puts "Job #{id} has been completed."
        rescue ArgumentError => e
          @statuses[id] = :failed
          puts "Job #{id} has failed: #{e.message}"
        end
      end

      def insert_product(_id, product)
        validate_keys!(product.keys)
        validate_product_unique!(product[:id])
        ::Product.add(product)
        puts "Product #{product[:id]} has been inserted."
      end

      def validate_keys!(keys)
        missing_keys = ::Product::REQUIRED_KEYS - keys
        return if missing_keys.empty?

        raise ArgumentError, "Missing required keys: #{missing_keys.join(', ')}"
      end

      def validate_product_unique!(id)
        return unless ::Product.find(id)

        raise ArgumentError, 'Product ID must be unique'
      end
    end
  end
end
