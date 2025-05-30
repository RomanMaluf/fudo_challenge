# frozen_string_literal: true

class Product
  REQUIRED_KEYS = %i[id name].freeze
  @products = begin
    JSON.parse(File.read('public/products.json'), symbolize_names: true)
  rescue StandardError
    []
  end

  def self.find(id)
    @products.find { |product| product[:id].to_s == id.to_s }
  end

  def self.all
    @products
  end

  def self.add(product)
    @products << product
  end
end
