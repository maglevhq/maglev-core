# frozen_string_literal: true

require 'rails_helper'

describe Maglev::AppContainer do
  let(:controller) { double('ApplicationController', site_preview_path: '/maglev/preview') }
  let(:context) { Maglev::ServiceContext.new(controller: controller, rendering_mode: :editor) }
  let(:container) { Maglev.services(context: context, config: 'Hello world') }

  it 'returns the base url' do
    expect(container.get_base_url.call).to eq '/maglev/preview'
  end
end
