# frozen_string_literal: true

require 'rails_helper'

describe Maglev::AppContainer do
  let(:controller) { double('ApplicationController') }
  let(:container) { Maglev.services(controller: controller, config: 'Hello world') }

  it 'returns the base url' do
    expect(container.get_base_url.call).to eq '/maglev/preview'
  end
end
