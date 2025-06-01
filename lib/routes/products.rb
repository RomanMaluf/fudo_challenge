# frozen_string_literal: true

module Routes
  # Products Route Handler
  class Products
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

    def self.handle_get_request(_env)
      serve_products
    end

    def self.handle_post_request(env)
      product = env[:body].transform_keys(&:to_sym)
      ResponseBuilder.build(201,
                            body: { message: 'Product enqueued for insertion', product: product,
                                    job_id: enqueue_insert_product(product) })
    end

    def self.serve_products
      ResponseBuilder.build(200, body: { products: Product.all })
    end

    def self.enqueue_insert_product(product)
      job_id = SecureRandom.uuid
      ::Jobs::InsertProduct.enqueue(job_id, product)
      job_id
    end
  end
end
