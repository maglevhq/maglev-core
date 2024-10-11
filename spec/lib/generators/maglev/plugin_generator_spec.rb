# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/maglev/plugin_generator'

destination_path = File.expand_path('../tmp', __dir__)

describe Maglev::PluginGenerator, type: :generator do
  destination destination_path

  arguments %w[maglev_dummy]

  before(:all) do
    prepare_destination
    FileUtils.touch(File.join(destination_path, 'Gemfile'))
    run_generator
  end

  it 'creates a new local Rails engine' do
    assert_file 'packages/maglev_dummy/maglev_dummy.gemspec'
    assert_file 'packages/maglev_dummy/index.js', /export default function\(\) \{/
    assert_file 'packages/maglev_dummy/package.json'
    assert_file 'packages/maglev_dummy/lib/maglev_dummy.rb'
    assert_file 'packages/maglev_dummy/lib/maglev_dummy/engine.rb', /register_plugin/
    assert_file 'packages/maglev_dummy/lib/maglev_dummy/version.rb', /0\.0\.1/
    assert_file 'app/frontend/editor/plugins/maglev_dummy.js', /from 'maglev_dummy'/
  end
end
