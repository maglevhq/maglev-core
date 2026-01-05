# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPublishedPageSectionsService do
  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:get_page_sections) { double('GetPageSections', call: nil) }
  let(:service) { described_class.new(get_page_sections: get_page_sections) }

  subject { service.call(page: page, locale: :en) }

  it 'calls the get_page_sections service' do
    expect(get_page_sections).to receive(:call).with(page: page, locale: :en, published: true).and_return(nil)
    subject
  end
end
