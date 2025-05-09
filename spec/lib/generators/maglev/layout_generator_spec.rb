# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/maglev/layout_generator'

describe Maglev::LayoutGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before(:all) do
    prepare_destination

    # Create a mock theme.yml file
    FileUtils.mkdir_p(File.join(destination_root, 'app/theme'))
    File.write(File.join(destination_root, 'app/theme/theme.yml'), <<~YAML)
      id: "theme"
      name: "My Theme"
      layouts:
      - name: default
        groups:
        - id: body

      # [LAYOUTS] DO NOT REMOVE THIS LINE

      mirror_section: false
    YAML

    # Run the generator with arguments
    run_generator(['two_column', '--groups', 'header', 'main*', 'sidebar'])
  end

  after(:all) do
    # Clean up
    FileUtils.rm_rf(destination_root)
  end

  it 'creates the layout template file' do
    assert_file 'app/views/theme/layouts/two_column.html.erb'
  end

  it 'creates a layout with the correct structure' do
    assert_file 'app/views/theme/layouts/two_column.html.erb' do |content|
      assert_match(/<!DOCTYPE html>/, content)
      assert_match(/data-maglev-header-dropzone/, content)
      assert_match(/data-maglev-main-dropzone/, content)
      assert_match(/data-maglev-sidebar-dropzone/, content)
      assert_match(/<%= render_maglev_group :sidebar %>/, content)
    end
  end

  it 'updates theme.yml with the new layout' do
    assert_file 'app/theme/theme.yml' do |content|
      # Check if the new layout is added after the default layout
      assert_match(/name: default.*name: two_column/m, content)
      # Check if all groups are present
      assert_match(/- id: header/, content)
      assert_match(/- id: main$/, content)
      assert_match(/- id: sidebar/, content)
      assert_match(/store: page$/, content)
    end
  end

  context 'when layout already exists' do
    before(:all) do
      run_generator(['two_column', '--groups', 'header', 'main*', 'sidebar'])
    end

    it 'does not duplicate the layout in theme.yml' do
      content = File.read(File.join(destination_root, 'app/theme/theme.yml'))
      layout_count = content.scan(/name: two_column/).count
      expect(layout_count).to eq(1)
    end
  end
end
