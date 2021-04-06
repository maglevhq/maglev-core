# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/maglev/section_generator'

describe Maglev::SectionGenerator, type: :generator do
  BLOCK_SETTINGS = 'title:text block:item:title block:item:image:image_picker block:item:description'

  destination File.expand_path('../tmp', __dir__)

  arguments ['showcase', '--theme=simple', '--settings', BLOCK_SETTINGS]

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates the YAML file to describe the section and its HTML/ERB template' do
    assert_file 'app/theme/sections/showcase.yml', /name: "showcase"/
    assert_file 'app/views/theme/sections/showcase.html.erb'
  end
end
