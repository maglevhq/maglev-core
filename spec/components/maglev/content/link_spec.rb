# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::Link do
  let(:section_component) { double('Maglev::SectionComponent') }
  let(:link) { Maglev::Content::Link.new(section_component, content, setting) }

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
  end

  context 'data provided by section yaml' do
    let(:content) { { link_type: 'url', href: '/contact_us' } }
    let(:setting) do
      double('Maglev::Section::Setting', default: '/contact_us', id: 'button', label: 'Button', type: 'link',
             options: { with_text: true, text: 'Call now!', open_new_window: true })
    end

    describe 'to_s method' do
      it { expect(link.to_s).to eq('/contact_us') }
    end

    describe 'href method' do
      it { expect(link.href).to eq('/contact_us') }
    end

    describe 'text method' do
      it { expect(link.text).to eq('Call now!') }
    end

    describe 'with_text? method' do
      it { expect(link.with_text?).to eq(true) }
    end

    describe 'open_new_window? method' do
      it { expect(link.open_new_window?).to eq(false) }
    end
  end

  context 'data provided by DB' do
    let(:content) do
      { link_type: 'url', href: '/contact_us', with_text: false, text: 'Call Tomorrow :D',
        open_new_window: true }
    end
    let(:setting) do
      double('Maglev::Section::Setting', default: '/contact_us', id: 'button', label: 'Button', type: 'link',
             options: { with_text: true, text: 'Call now!', open_new_window: true })
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
      it { expect(link.with_text?).to eq(false) }
    end

    describe 'open_new_window? method' do
      it { expect(link.open_new_window?).to eq(true) }
    end
  end
end