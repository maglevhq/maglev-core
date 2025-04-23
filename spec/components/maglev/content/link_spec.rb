# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::Link do
  let(:section_component) { double('Maglev::SectionComponent') }
  let(:link) { described_class.new(section_component, content, setting) }
  let(:scope) { double('Scope', page: double('Page', id: 1)) }

  before do
    allow(link).to receive(:scope).and_return(scope)
  end

  context 'content is a string' do
    let(:content) { '/contact_us' }
    let(:setting) do
      double('Maglev::Section::Setting', default: '/contact_us', id: 'button', label: 'Button', type: 'link',
                                         options: {})
    end

    describe 'to_s method' do
      it { expect(link.to_s).to eq('/contact_us') }
    end

    describe 'href method' do
      it { expect(link.href).to eq('/contact_us') }
    end

    describe 'text method' do
      it { expect(link.text).to be_nil }
    end

    describe 'with_text? method' do
      it { expect(link.with_text?).to eq(false) }
    end

    describe 'open_new_window? method' do
      it { expect(link.open_new_window?).to eq(false) }
    end

    describe 'active? method' do
      it { expect(link.active?).to eq(false) }
    end
  end

  context 'data provided by section yaml' do
    let(:content) { { link_type: 'url', href: '/contact_us' } }
    let(:setting) do
      double('Maglev::Section::Setting', default: '/contact_us', id: 'button', label: 'Button', type: 'link',
                                         options: { with_text: true, open_new_window: true })
    end

    describe 'to_s method' do
      it { expect(link.to_s).to eq('/contact_us') }
    end

    describe 'href method' do
      it { expect(link.href).to eq('/contact_us') }
    end

    describe 'text method' do
      it { expect(link.text).to be_nil }
    end

    describe 'with_text? method' do
      it { expect(link.with_text?).to eq(true) }
    end

    describe 'open_new_window? method' do
      it { expect(link.open_new_window?).to eq(false) }
    end

    describe 'active? method' do
      it { expect(link.active?).to eq(false) }
    end
  end

  context 'data provided by DB' do
    let(:content) do
      { link_type: 'url', href: '/contact_us', text: 'Call Tomorrow :D',
        open_new_window: true }
    end
    let(:setting) do
      double('Maglev::Section::Setting', default: '/contact_us', id: 'button', label: 'Button', type: 'link',
                                         options: { with_text: true, open_new_window: true })
    end

    describe 'to_s method' do
      it { expect(link.to_s).to eq('/contact_us') }
    end

    describe 'href method' do
      it { expect(link.href).to eq('/contact_us') }
    end

    describe 'text method' do
      it { expect(link.text).to eq('Call Tomorrow :D') }
    end

    describe 'with_text? method' do
      it { expect(link.with_text?).to eq(true) }
    end

    describe 'open_new_window? method' do
      it { expect(link.open_new_window?).to eq(true) }
    end

    describe 'active? method' do
      it { expect(link.active?).to eq(false) }

      context 'when link type is page and matches current path' do
        let(:content) do
          { link_type: 'page', link_id: 1, text: 'Call Tomorrow :D',
            open_new_window: true }
        end
        it { expect(link.active?).to eq(true) }
      end

      context 'when link type is page but does not match current path' do
        let(:content) do
          { link_type: 'page', link_id: 2, text: 'Call Tomorrow :D',
            open_new_window: true }
        end
        it { expect(link.active?).to eq(false) }
      end
    end
  end
end
