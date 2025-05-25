# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetBaseUrl do
  subject { service.call(preview_mode: preview_mode) }

  let(:site) { build(:site) }
  let(:controller) { double('Controller', site_preview_path: '/maglev/preview') }
  let(:service) do
    described_class.new(
      fetch_site: double('FetchSite', call: site),
      context: double('Context', rendering_mode: rendering_mode, controller: controller)
    )
  end

  context 'no preview mode is passed to the service' do
    let(:preview_mode) { nil }

    context 'the rendering mode is editor' do
      let(:rendering_mode) { :editor }

      it { is_expected.to eq '/maglev/preview' }
    end

    context 'the rendering mode is live' do
      let(:rendering_mode) { :live }

      it { is_expected.to eq nil }
    end
  end

  context 'preview mode is false' do
    let(:preview_mode) { false }
    let(:rendering_mode) { :editor }

    context 'the site has no domain' do
      it "doesn't need the rendering_mode variable" do
        expect(subject).to eq nil
      end
    end
  end

  context 'preview mode is true' do
    let(:preview_mode) { true }
    let(:rendering_mode) { :live }

    it "doesn't need the rendering_mode variable" do
      expect(subject).to eq '/maglev/preview'
    end
  end
end
