# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Uikit::Form::LinkComponent do
  describe '.link_type_component' do
    let(:input_name) { 'section[settings][cta]' }
    let(:path) { '/editor/links/:id/edit' }

    def call(value)
      described_class.link_type_component(
        input_name: input_name,
        value: value.with_indifferent_access,
        path: path
      )
    end

    # Regression: fetch(..., 'url') used a String default, so unknown/missing
    # link_type led to NoMethodError (undefined method `new' for String).
    context 'when link_type is missing, blank, or unknown (invalid fetch default was the string "url")' do
      it 'returns UrlLinkComponent for nil link_type' do
        expect(call(link_type: nil, href: 'https://example.com'))
          .to be_a(Maglev::Uikit::Form::Link::UrlLinkComponent)
      end

      it 'returns UrlLinkComponent for blank link_type' do
        expect(call(link_type: '', href: '/'))
          .to be_a(Maglev::Uikit::Form::Link::UrlLinkComponent)
      end

      it 'returns UrlLinkComponent for an unmapped link_type' do
        expect(call(link_type: 'legacy_or_custom', href: '/'))
          .to be_a(Maglev::Uikit::Form::Link::UrlLinkComponent)
      end
    end

    context 'when link_type is mapped' do
      it 'returns PageLinkComponent for page' do
        expect(call(link_type: 'page', link_id: 1))
          .to be_a(Maglev::Uikit::Form::Link::PageLinkComponent)
      end

      it 'returns UrlLinkComponent for url' do
        expect(call(link_type: 'url', href: '/'))
          .to be_a(Maglev::Uikit::Form::Link::UrlLinkComponent)
      end
    end
  end
end
