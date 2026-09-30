# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Editor::Settings::Text::RichtextComponent, type: :component do
  let(:options) { { html: true } }
  let(:definition) { build(:section_setting, :richtext, options: options) }
  let(:instance) do
    described_class.new(definition: definition, value: '<p>Hello</p>', paths: { edit_link_path: '/links/edit' },
                        scope: { input: 'section', i18n: 'maglev.editor' })
  end

  subject { render_inline(instance) }

  before do
    vc_test_view_context.class.include(Maglev::ApplicationHelper)
  end

  it 'renders the editor with the default number of rows' do
    subject
    expect(rendered_content).to have_selector('[style*="--number-of-rows: 4;"]')
  end

  context 'when the setting defines nb_rows' do
    let(:options) { { html: true, nb_rows: 15 } }

    it 'sizes the editor to that number of rows' do
      subject
      expect(rendered_content).to have_selector('[style*="--number-of-rows: 15;"]')
    end
  end
end
