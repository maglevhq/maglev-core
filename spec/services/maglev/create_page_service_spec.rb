# frozen_string_literal: true

require 'rails_helper'

describe Maglev::CreatePageService do
  let(:fetch_site) { double('FetchSite', call: build(:site)) }
  let(:attributes) { { title: 'Hello world', path: 'hello-world' } }
  let(:service) { described_class.new(fetch_site: fetch_site) }

  subject { service.call(attributes: attributes) }

  it 'creates the page in all the site locales' do
    expect { subject }.to change(Maglev::Page, :count).by(1)
    expect(subject.title).to eq 'Hello world'
    expect(subject.path).to eq 'hello-world'
    # rubocop:disable Style/StringHashKeys
    expect(subject.title_translations).to eq({ 'en' => 'Hello world', 'fr' => 'Hello world' })
    # rubocop:enable Style/StringHashKeys
    expect(subject.path_hash.keys).to eq(%w[en fr])
    expect(subject.path_hash.values[0]).to eq 'hello-world'
    expect(subject.path_hash.values[1]).to eq 'hello-world'
  end
end
