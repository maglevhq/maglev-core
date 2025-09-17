# frozen_string_literal: true

require 'rails_helper'

describe 'Maglev::Editor::IconsController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }

  describe 'GET /maglev/editor/icons' do
    it 'returns a success response' do
      get '/maglev/editor/icons', params: { source_id: 'icon-input' }, headers: { "Turbo-Frame": 'modal' }
      expect(response).to be_successful
    end
  end
end
