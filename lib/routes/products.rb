module Routes
  class Products
    REQUIRED_KEYS = [:name, :price, :category, :id].freeze
    
    def self.route(env)
      case env[:request_method]
      when :get
        handle_get_request(env)
      when :post
        handle_post_request(env)
      else
        raise NotFoundError, "Unsupported method: #{env[:request_method]}"
      end
    end

    def self.handle_get_request(env)
      serve_products
    end

    def self.handle_post_request(env)
      product = env[:body].transform_keys(&:to_sym)
      insert_product(product)
      ResponseBuilder.build(201, body: { product: })
    end

    private

    def self.serve_products
      ResponseBuilder.build(200, body: { products: $products })
    end

    def self.insert_product(product)
      validate_keys! product.keys
      validate_product_unique! request_body[:id]

      $products << product
    end

    def self.validate_keys!(keys)
      missing_keys = REQUIRED_KEYS - keys
      return if missing_keys.empty?

      raise ArgumentError, "Missing required keys: #{missing_keys.join(', ')}"
    end

    def self.validate_product_unique!(id)
      if $products.any? { |p| p[:id].to_s == id.to_s }
        raise ArgumentError, "Product ID must be unique"
      end
    end
  end
end