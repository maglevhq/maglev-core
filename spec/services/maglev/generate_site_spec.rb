# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GenerateSite do
  let(:service) do
    described_class.new(
      fetch_theme: double('FetchTheme', call: build(:theme, :predefined_pages)),
      setup_pages: Maglev::SetupPages.new
    )
  end
  subject { service.call }

  it 'creates a new site' do
    expect { subject }.to change(Maglev::Site, :count).by(1)
                                                      .and change(Maglev::Page, :count).by(2)
  end
end
