# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchCollectionItems do
  let(:fetch_method_name) { nil }
  let(:config) do
    Maglev::Config.new.tap do |config|
      config.collections = {
        products: {
          model: 'Product',
          fetch_method_name: fetch_method_name,
          fields: {
            label: :name,
            image: :thumbnail_url
          }
        }
      }
    end
  end
  let(:service) { described_class.new(config: config, fetch_site: instance_double('FetchSite', call: nil)) }

  describe 'fetching the first N items' do
    subject { service.call(collection_id: 'products') }

    before do
      FactoryBot.rewind_sequences
      create_list(:product, 12, :without_thumbnail)
    end

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
    subject { service.call(collection_id: 'products', id: product_id) }

    let!(:product) { create(:product, name: 'My product') }

    context 'the id doesn\'t belong to an existing item' do
      let(:product_id) { product.id + 1 }

      it 'returns nil' do
        expect(subject).to eq nil
      end
    end

    context 'the id belongs to an existing item' do
      let(:product_id) { product.id }

      it 'returns the item' do
        expect(subject.label).to eq 'My product'
      end
    end

    context 'the id is "any"' do
      let(:product_id) { 'any' }

      it 'returns the first item in DB' do
        expect(subject.label).to eq 'My product'
      end
    end
  end

  describe 'passing a custom fetch method' do
    describe 'fetching the first N items' do
      subject { service.call(collection_id: 'products') }

      let(:fetch_method_name) { :maglev_fetch_sold_out }

      before do
        FactoryBot.rewind_sequences
        create_list(:product, 4, :without_thumbnail)
        create_list(:product, 4, :without_thumbnail, :sold_out)
      end

      it 'returns only the sold outitems' do
        expect(subject.map(&:label)).to eq(['Product #05', 'Product #06', 'Product #07', 'Product #08'])
      end
    end
  end
end
