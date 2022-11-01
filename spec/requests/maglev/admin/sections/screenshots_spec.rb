# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::Admin::Sections::ScreenshotsController', type: :request do
  let(:service) { double('PersistSectionScreenshot') }

  before do
    allow(Maglev).to receive(:services).and_return(double('AppContainer', persist_section_screenshot: service))
  end

  it 'calls the take_section_screenshot service' do
    expect(service).to receive(:call).with(
      section_id: 'jumbotron',
      base64_image: 'data:image/png;base64,bodyofthepngfile'
    )
    post '/maglev/admin/sections/jumbotron/screenshots',
         params: { screenshot: { base64_image: 'data:image/png;base64,bodyofthepngfile' } }
  end
end
