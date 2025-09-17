# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Editor::SettingsGroupComponent, type: :component do
  let(:section) { build(:section, :all_settings) }
  let(:settings) { section.settings }
  let(:values) { [] }
  let(:paths) do
    {
      collection_items_path: ->(definition, _) { "/collection_items/#{definition.options[:collection_id]}" },
      assets_path: ->(_, context) { "/assets?source=#{context[:source]}&picker=true" },
      edit_link_path: '/links/edit',
      icons_path: '/icons'
    }
  end
  let(:instance) do
    described_class.new(values: values, definitions: settings, paths: paths,
                        scope: { input: 'section', i18n: 'maglev.editor' })
  end

  subject { render_inline(instance) }

  before do
    vc_test_view_context.class.include(Maglev::ApplicationHelper)
  end

  it 'renders all settings' do
    subject
    expect(rendered_content).to have_selector('div', text: 'Link')
    expect(rendered_content).to have_selector('div', text: 'Simple Text 🍔')
    expect(rendered_content).to have_selector('div', text: 'Richtext 🍔')
    expect(rendered_content).to have_selector('div', text: 'Textarea 🍔')
    expect(rendered_content).to have_selector('div', text: 'Image 🍔')
    expect(rendered_content).to have_selector('div', text: 'Checkbox 🍔')
    expect(rendered_content).to have_selector('div', text: 'Select 🍔')
  end
end
