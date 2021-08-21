# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchCollectionItems do
  let(:config) do
    Maglev::Config.new.tap do |config|
      config.collections = {
        products: {
          model: 'Product',
          fields: {
            label: :name,
            image: :thumbnail_url
          }
        }
      }
    end
  end
  let(:service) { described_class.new(config: config, fetch_site: nil) }

  describe 'fetching the first N items' do
    before do
      FactoryBot.rewind_sequences
      create_list(:product, 12, :without_thumbnail)
    end
    subject { service.call(collection_id: 'products') }
    it 'returns the first N items' do
      expect(subject.size).to eq(10)
      expect(subject.first.label).to eq 'Product #01'
      expect(subject.last.label).to eq 'Product #10'
    end
    context 'filtering by a keyword' do
      subject { service.call(collection_id: 'products', keyword: '#1') }
      it 'returns the items which label matches the keyword' do
        expect(subject.map(&:label)).to eq(['Product #10', 'Product #11', 'Product #12'])
      end
    end
  end

  describe 'fetching one single item' do
    let(:product) { create(:product, name: 'My product') }
    subject { service.call(collection_id: 'products', id: product_id) }
    context 'the id doesn\'t belong to an existing item' do
      let(:product_id) { product.id + 1 }
      it 'returns nil' do
        is_expected.to eq nil
      end
    end
    context 'the id belongs to an existing item' do
      let(:product_id) { product.id }
      it 'returns the item' do
        expect(subject.label).to eq 'My product'
      end
    end
  end
end
