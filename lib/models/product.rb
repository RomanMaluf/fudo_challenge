# frozen_string_literal: true

class Product
  REQUIRED_KEYS = %i[id name].freeze
  @products = JSON.parse(File.read('public/products.json'), symbolize_names: true)

  class << self
    def find(id)
      @products.find { |product| product[:id].to_s == id.to_s }
    end

    def all
      @products
    end

    def add(product)
      @products << product
    end
  end
end
