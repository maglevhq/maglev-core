# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchStyle do
  let!(:site) { create(:site) }
  let!(:theme) { build(:theme) }
  let(:fetch_site) { instance_double('FetchSite', call: site) }
  let(:fetch_theme) { instance_double('FetchTheme', call: theme) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject { service.call }

  context 'the site has no style settings' do
    it 'uses the default values from the theme' do
      expect(subject.primary_color).to eq('#f00')
      expect(subject.font_name).to eq('comic sans')
    end
  end

  context 'the site has style settings filled by the editor' do
    let!(:site) { create(:site, :with_style) }

    it 'uses the values from the site model' do
      expect(subject.primary_color).to eq('#ff00ff')
      expect(subject.font_name).to eq('roboto')
    end
  end
end
