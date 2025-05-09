# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::UpgradeFromV1, type: :service do
  let(:site) { create(:site) }
  let(:theme) { build(:theme, :v1) }
  let!(:page) do
    build(:page) do |page|
      page['sections_translations'] = {
        en: [{ type: 'hero' }],
        fr: [{ type: 'hero', settings: { title: 'Bonjour' } }]
      }
      page.save!
    end
  end

  subject { described_class.call(site: site, theme: theme) }

  it 'creates a SectionsContentStore for both the site and the page' do
    expect_any_instance_of(described_class).to receive(:persist_layout_template).with(
      a_string_including('data-maglev-main-dropzone'),
      'default.html.erb'
    )
    expect { subject }.to change { Maglev::SectionsContentStore.count }.by(2)

    store = Maglev::SectionsContentStore.find_by(handle: "main-#{page.id}")
    expect(store.sections_translations['en'].first['type']).to eq('hero')
    expect(store.sections_translations['fr'].first['settings']['title']).to eq('Bonjour')

    expect(page.reload.layout_id).to eq('default')
  end
end
