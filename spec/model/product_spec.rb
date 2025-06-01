# frozen_string_literal: true

require_relative '../../lib/models/product'

RSpec.describe Product do
  let(:sample_product) { { id: 1, name: 'Sample Product' } }

  before do
    described_class.instance_variable_set(:@products, [sample_product])
  end

  describe '.all' do
    it 'returns all products' do
      expect(Product.all).to eq([sample_product])
    end
  end

  describe '.find' do
    it 'returns product by ID as integer' do
      expect(Product.find(1)).to eq(sample_product)
    end

    it 'returns product by ID as string' do
      expect(Product.find('1')).to eq(sample_product)
    end

    it 'returns nil for unknown ID' do
      expect(Product.find(999)).to be_nil
    end
  end

  describe '.add' do
    it 'adds a new product to the list' do
      new_product = { id: 2, name: 'New Product' }
      Product.add(new_product)
      expect(Product.all).to include(new_product)
    end
  end
end
