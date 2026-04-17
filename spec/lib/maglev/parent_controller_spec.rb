# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev parent controller' do
  describe '.parent_controller_class' do
    context 'with default config' do
      it 'resolves to the host ApplicationController' do
        expect(Maglev.parent_controller_class).to eq(::ApplicationController)
      end
    end

    context 'with a custom parent_controller' do
      around do |example|
        original = Maglev.config.parent_controller
        Maglev.config.parent_controller = 'CustomBaseController'
        example.run
        Maglev.config.parent_controller = original
      end

      it 'resolves to the configured class' do
        expect(Maglev.parent_controller_class).to eq(CustomBaseController)
      end

      it 'lets a newly defined controller inherit that parent (same mechanism as Maglev::ApplicationController)' do
        k = Class.new(Maglev.parent_controller_class)
        expect(k.superclass).to eq(CustomBaseController)
      end
    end
  end

  describe Maglev::ApplicationController do
    it 'inherits from the host ApplicationController by default' do
      expect(described_class.superclass).to eq(::ApplicationController)
    end
  end
end
