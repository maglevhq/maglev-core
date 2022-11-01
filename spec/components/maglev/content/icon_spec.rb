# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::Icon do
  let(:section_component) { double('Maglev::SectionComponent', id: 'my-section') }
  let(:instance) { described_class.new(section_component, content, setting) }
  let(:content) { 'fancy-icon-class' }
  let(:setting) do
    double('Maglev::Section::Setting', default: 'default-icon-class', id: 'my_icon', label: 'Icon', type: 'icon',
                                       options: {})
  end

  describe '#to_s' do
    it { expect(instance.to_s).to eq('fancy-icon-class') }
  end

  describe '#icon_class' do
    it { expect(instance.icon_class).to eq('fancy-icon-class') }
  end

  describe '#blank?' do
    it { expect(instance.blank?).to eq(false) }
  end

  describe '#tag' do
    subject { view_context.render(inline: template, locals: { section: section_component }) }

    let(:template) do
      <<~HTML
        <%= section.setting_tag :my_icon, class: 'maglev-icon' %>
      HTML
        .strip
    end
    let(:view_context) { ApplicationController.new.view_context }

    before do
      allow(section_component).to receive(:setting_tag) { |_collection_id, &block|
                                    instance.tag(view_context, { class: 'maglev-icon' }, &block)
                                  }
    end

    context 'no content' do
      let(:content) { nil }

      it {
        expect(subject).to eq(<<~HTML
          <i class="maglev-icon" data-maglev-id="my-section.my_icon"></i>
        HTML
      .strip)
      }
    end

    context 'the content is an icon class' do
      let(:content) { 'fancy-icon-class' }

      it {
        expect(subject).to eq(<<~HTML
          <i class="maglev-icon fancy-icon-class" data-maglev-id="my-section.my_icon"></i>
        HTML
      .strip)
      }
    end
  end
end
