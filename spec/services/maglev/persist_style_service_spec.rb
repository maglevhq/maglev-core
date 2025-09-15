# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PersistStyleService do
  let(:site) { create(:site, :with_style) }
  let(:theme) { build(:theme) }
  let(:fetch_site) { instance_double('FetchSite', call: site) }
  let(:fetch_theme) { instance_double('FetchTheme', call: theme) }
  let(:new_style) { { 'font_name' => 'Nunito' } }

  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject { service.call(new_style: new_style) }

  it 'persists the style' do
    expect(subject).to eq true
    expect(site.reload.style).to include({ 'id' => 'font_name', 'value' => 'Nunito', 'type' => 'text' })
  end
end