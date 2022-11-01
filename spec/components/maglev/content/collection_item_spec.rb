# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::CollectionItem do
  let(:section_component) { instance_double('Maglev::SectionComponent', id: 'my-section') }
  let(:setting) do
    double('Maglev::Section::Setting', id: 'product', label: 'Product', type: 'collection_item',
                                       options: { collection_id: 'products' })
  end
  let(:item) { instance_double('Product', name: 'My product', sku: 'REF-0001') }
  let(:instance) { described_class.new(section_component, content, setting) }

  describe '#exists?' do
    subject { instance.exists? }

    context 'no content' do
      let(:content) { nil }

      it { is_expected.to eq(false) }
    end

    context 'the content references the model instance' do
      let(:content) { { item: item } }

      it { is_expected.to eq(true) }
    end
  end

  describe '#tag' do
    subject { view_context.render(inline: template, locals: { section: section_component }) }

    let(:template) do
      <<~HTML
        <%= section.setting_tag :product do |product| %>
          <h1><%= product.name %></h1>
          <p><%= product.sku %></p>
        <% end %>
      HTML
        .strip
    end
    let(:view_context) { ApplicationController.new.view_context }

    before do
      allow(section_component).to receive(:setting_tag) { |_collection_id, &block|
                                    instance.tag(view_context, {}, &block)
                                  }
    end

    context 'no content' do
      let(:content) { nil }

      it { is_expected.to eq('') }
    end

    context 'the content references the model instance' do
      let(:content) { { item: item } }

      it {
        expect(subject).to eq(<<~HTML
          <div data-maglev-id="my-section.product">
            <h1>My product</h1>
            <p>REF-0001</p>
          </div>
        HTML
      .strip)
      }
    end
  end
end
