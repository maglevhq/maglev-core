# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/maglev/setting_type_generator'

destination_path = File.expand_path('../tmp', __dir__)

describe Maglev::SettingTypeGenerator, type: :generator do
  destination destination_path

  arguments %w[radio_button --plugin=maglev_dummy]

  before(:all) do
    prepare_destination
    plugin_path = File.join(destination_path, 'packages', 'maglev_dummy')
    FileUtils.mkdir_p(File.join(plugin_path, 'lib', 'maglev_dummy'))
    File.open(File.join(plugin_path, 'lib', 'maglev_dummy', 'engine.rb'), 'w+') do |f|
      f.write(
<<-RUBY
module MaglevDummy
  class Engine < ::Rails::Engine
    isolate_namespace MaglevDummy
  end
end
RUBY
      )
    end
    File.open(File.join(plugin_path, 'index.js'), 'w+') do |f|
      f.write(
<<-JAVASCRIPT
export default function() {
  console.log('👋 Hello from the <%= human_name %> plugin v0.0.1')
}
JAVASCRIPT
      )
    end
    run_generator
  end

  it 'generates all the files required for a new custom setting type' do
    assert_file 'packages/maglev_dummy/app/models/maglev/setting_types/radio_button.rb', /RadioButton < Maglev::SettingTypes::Base/
    assert_file 'packages/maglev_dummy/app/components/maglev/content/radio_button.rb', /class RadioButton < Maglev::Content::Base/

    assert_file 'packages/maglev_dummy/lib/maglev_dummy/engine.rb', /Maglev\.register_setting_type\(id: :radio_button\)/
    
    assert_file 'packages/maglev_dummy/app/frontend/editor/components/kit/radio-button.vue', /name: 'UIKitRadioButtonInput'/    

    assert_file 'packages/maglev_dummy/index.js', /registerInput('radio_button', UIKitRadioButtonInput, (props, _options) => props)/
  end
end
