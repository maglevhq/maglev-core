# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchThemeLayout do
  let(:service) { described_class.new }
  let(:page) { build(:page) }

  subject { service.call(page: page) }

  it { is_expected.to eq 'theme/layouts/default' }

  context 'legacy page with no layout_id' do
    let(:page) { build(:page, layout_id: nil) }
    it { expect { subject }.to raise_error(Maglev::Errors::MissingLayout) }
  end
end
